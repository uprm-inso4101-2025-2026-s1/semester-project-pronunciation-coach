"""
Audio Challenge Logic - Business logic for TTS pronunciation challenges
Automatically generates mispronunciations for any word
"""

import base64
import io
import random
import re
from typing import Dict, List, Tuple

from domain.utils.word_picker import get_word_by_difficulty
from gtts import gTTS


def split_into_syllables(word: str) -> List[str]:
    """
    Simple syllable splitter - splits on vowel groups
    """
    # Find vowel groups
    parts = re.split(r"([aeiou]+)", word.lower())
    # Combine consonants with following vowels
    syllables = []
    i = 0
    while i < len(parts):
        if parts[i]:
            if i + 1 < len(parts) and parts[i + 1]:
                syllables.append(parts[i] + parts[i + 1])
                i += 2
            else:
                syllables.append(parts[i])
                i += 1
        else:
            i += 1
    return [s for s in syllables if s]


def mispronounce_stress_wrong_syllable(word: str) -> str:
    """
    Put stress on wrong syllable by repeating it
    Example: "beautiful" -> "beau beau tiful"
    """
    syllables = split_into_syllables(word)
    if len(syllables) < 2:
        # Short word - just emphasize first part
        return (
            f"{word[:2]} {word[:2]} {word[2:]}" if len(word) > 3 else word + " " + word
        )

    # Emphasize wrong syllable (not first, which is usually correct)
    wrong_index = random.randint(1, len(syllables) - 1)
    syllables[wrong_index] = syllables[wrong_index] + " " + syllables[wrong_index]

    return " ".join(syllables)


def mispronounce_add_schwa(word: str) -> str:
    """
    Add schwa sound (uh) in wrong places
    Example: "comfortable" -> "com fuh table"
    """
    syllables = split_into_syllables(word)
    if len(syllables) < 2:
        # Insert 'uh' in middle
        mid = len(word) // 2
        return f"{word[:mid]} uh {word[mid:]}"

    # Add 'uh' between syllables
    result = []
    for i, syl in enumerate(syllables):
        result.append(syl)
        if i < len(syllables) - 1 and random.random() > 0.5:
            result.append("uh")

    return " ".join(result)


def mispronounce_wrong_vowel(word: str) -> str:
    """
    Change vowel sounds to common mispronunciations
    Example: "said" -> "sade", "women" -> "woe men"
    """
    word_lower = word.lower()

    # Common vowel sound substitutions
    substitutions = [
        # (pattern, replacement, description)
        (r"ea", "ay", "long a sound"),  # "bread" -> "brayd"
        (r"oo", "oe", "long o sound"),  # "book" -> "boek"
        (r"ou", "ow", "ow sound"),  # "could" -> "cowld"
        (r"igh", "eye", "eye sound"),  # "night" -> "neyet"
        (r"ai", "eye", "eye sound"),  # "said" -> "seyed"
        (r"ei", "ee", "long e"),  # "receive" -> "receeve"
        (r"ie", "eye ee", "separate sounds"),  # "friend" -> "frey end"
        (r"tion", "tee on", "separate"),  # "nation" -> "nay tee on"
    ]

    # Try each substitution
    for pattern, replacement, _ in substitutions:
        if re.search(pattern, word_lower):
            result = re.sub(pattern, replacement, word_lower, count=1)
            # Make sure it actually changed
            if result != word_lower:
                return result

    # Fallback: split at first vowel
    match = re.search(r"[aeiou]", word_lower)
    if match:
        pos = match.start()
        return f"{word_lower[:pos]} {word_lower[pos:pos+2]} {word_lower[pos+2:]}"

    return word_lower


def mispronounce_consonant_cluster(word: str) -> str:
    """
    Break up consonant clusters incorrectly
    Example: "string" -> "suh tring", "school" -> "suh kool"
    """
    word_lower = word.lower()

    # Common consonant clusters at start
    clusters = [
        "str",
        "spr",
        "thr",
        "chr",
        "sch",
        "spl",
        "scr",
        "squ",
        "tw",
        "tr",
        "dr",
        "cr",
        "br",
        "fr",
        "gr",
        "pr",
    ]

    for cluster in clusters:
        if word_lower.startswith(cluster):
            # Break it up: "str" -> "suh tr" or "s tur"
            return f"{cluster[0]} {cluster[1:]}{word_lower[len(cluster):]}"

    # Check for internal consonant clusters
    if len(word) > 4:
        # Find consonant pairs
        for i in range(len(word_lower) - 1):
            if word_lower[i] not in "aeiou" and word_lower[i + 1] not in "aeiou":
                # Found consonant cluster
                return f"{word_lower[:i+1]} uh {word_lower[i+1:]}"

    # Fallback: add 'uh' at end
    return f"{word_lower} uh"


def generate_mispronunciations(word: str) -> List[str]:
    """
    Generate three UNIQUE and REALISTIC mispronunciations

    Returns:
        List of 3 distinct wrong pronunciations
    """
    mispronunciations = []

    # Method 1: Wrong stress pattern
    misp1 = mispronounce_stress_wrong_syllable(word)
    mispronunciations.append(misp1)

    # Method 2: Wrong vowel sounds
    misp2 = mispronounce_wrong_vowel(word)
    mispronunciations.append(misp2)

    # Method 3: Add schwa or break consonants
    if random.random() > 0.5:
        misp3 = mispronounce_add_schwa(word)
    else:
        misp3 = mispronounce_consonant_cluster(word)
    mispronunciations.append(misp3)

    # Ensure all are unique and different from original
    unique_misps = []
    seen = {word.lower()}

    for misp in mispronunciations:
        # Clean and normalize
        misp_clean = misp.strip().lower()

        # Only add if unique
        if misp_clean not in seen and misp_clean != word.lower():
            unique_misps.append(misp)
            seen.add(misp_clean)

    # If we don't have 3 unique, create more variations
    backup_methods = [
        lambda w: f"{w[:2]} {w[2:]}",  # Split early
        lambda w: f"{w[:-2]} {w[-2:]}",  # Split late
        lambda w: f"{w[0]} {w[1:]}",  # Split first letter
    ]

    for method in backup_methods:
        if len(unique_misps) >= 3:
            break
        variant = method(word)
        if variant.lower() not in seen:
            unique_misps.append(variant)
            seen.add(variant.lower())

    # Last resort: add emphasis
    while len(unique_misps) < 3:
        variant = f"{word} {word}"  # Repeat word
        if variant.lower() not in seen:
            unique_misps.append(variant)
            seen.add(variant.lower())
        else:
            break

    print(f"   🔍 Mispronunciations for '{word}':")
    for i, misp in enumerate(unique_misps[:3], 1):
        print(f"      {i}. '{misp}'")

    return unique_misps[:3]


def get_pronunciation_variants(word: str) -> List[Dict[str, str]]:
    """
    Get pronunciation variants for a word - automatically generated
    """
    variants = []

    # Correct pronunciation
    variants.append(
        {"word": word, "spoken_text": word, "type": "correct", "pattern": "correct"}
    )

    # Generate three UNIQUE mispronunciations
    mispronunciations = generate_mispronunciations(word)

    # Verify uniqueness
    seen = {word}
    unique_misps = []
    for misp in mispronunciations:
        if misp not in seen:
            unique_misps.append(misp)
            seen.add(misp)

    # Add to variants
    for i, misp in enumerate(unique_misps[:3]):
        variants.append(
            {
                "word": word,
                "spoken_text": misp,
                "type": f"wrong_{i+1}",
                "pattern": f"mispronunciation_{i+1}",
            }
        )

    # Shuffle so correct answer isn't always in same position
    random.shuffle(variants)
    return variants


def generate_audio_for_variant(variant: Dict, format: str = "bytes") -> bytes:
    """
    Generate audio for a pronunciation variant

    Args:
        variant: Dict with 'spoken_text' and 'pattern'
        format: Output format ('base64' or 'bytes')

    Returns:
        Audio bytes (MP3 format)
    """
    try:
        spoken_text = variant["spoken_text"]
        pattern = variant["pattern"]

        print(f"    🔊 Generating TTS: '{spoken_text}' (pattern: {pattern})")

        # Use slow speech for emphasized pronunciations (30% chance)
        is_slow = "wrong" in pattern and random.random() > 0.7

        # Create TTS object
        tts = gTTS(text=spoken_text, lang="en", slow=is_slow, lang_check=False)

        # Save to BytesIO
        audio_fp = io.BytesIO()
        tts.write_to_fp(audio_fp)

        # Get the bytes
        audio_fp.seek(0)
        audio_bytes = audio_fp.read()

        print(f"    ✅ Generated {len(audio_bytes)} bytes of audio")

        if format == "base64":
            return base64.b64encode(audio_bytes).decode("utf-8")
        else:
            return audio_bytes

    except Exception as e:
        print(f"    ❌ Error generating audio: {e}")
        import traceback

        traceback.print_exc()
        # Return empty audio data
        if format == "base64":
            return ""
        else:
            return b""


def generate_audio_challenge(difficulty: str) -> Dict:
    """
    Generate a complete audio challenge with word and audio options

    Args:
        difficulty: "easy", "medium", or "hard"

    Returns:
        Dict with challenge data including audio
    """
    # Get random word based on difficulty
    word = get_word_by_difficulty(difficulty)

    print(
        f"🎯 Generating audio challenge for word: '{word}' (difficulty: {difficulty})"
    )

    # Get pronunciation variants (automatically generated)
    variants = get_pronunciation_variants(word)

    # Show what we generated
    print(f"\n   📝 Generated variants:")
    for v in variants:
        print(f"      {v['type']}: '{v['spoken_text']}'")
    print()

    # Find correct answer position
    correct_index = next(i for i, v in enumerate(variants) if v["type"] == "correct")
    correct_letter = chr(65 + correct_index)  # A, B, C, D

    # Generate challenge ID
    challenge_id = random.randint(10000, 99999)

    # Generate and cache audio for each variant
    from infrastructure.audio_cache import cache_audio, cache_challenge

    options_data = []
    for i, variant in enumerate(variants):
        option_letter = chr(65 + i)

        # Generate audio for this variant
        print(
            f"  🎵 Generating audio for option {option_letter} (type: {variant['type']})"
        )
        audio_bytes = generate_audio_for_variant(variant, format="bytes")

        # Debug: Check if audio was generated
        if audio_bytes:
            print(f"  ✅ Audio generated successfully: {len(audio_bytes)} bytes")
        else:
            print(f"  ⚠️  Warning: No audio data generated!")

        # Cache the audio
        cache_audio(challenge_id, option_letter, audio_bytes)

        options_data.append(
            {
                "letter": option_letter,
                "audio_url": f"/api/challenge/audio/{challenge_id}/option/{option_letter}",
                "pattern": variant["pattern"],
            }
        )

    # Cache challenge data
    cache_challenge(
        challenge_id,
        {
            "id": challenge_id,
            "word": word,
            "difficulty": difficulty,
            "correct_answer": correct_letter,
            "variants": variants,
        },
    )

    # XP reward based on difficulty
    xp_map = {"easy": 10, "medium": 15, "hard": 20}

    print(f"✅ Challenge {challenge_id} generated successfully!\n")

    return {
        "id": challenge_id,
        "word": word,
        "difficulty": difficulty,
        "content": f"Which pronunciation of '{word}' is correct?",
        "type": "audio_pronunciation",
        "xp_reward": xp_map[difficulty],
        "hint": f"Listen carefully to how each syllable is pronounced",
        "options": options_data,
        "correct_answer": correct_letter,
    }


def get_word_info(word: str) -> Dict:
    """
    Get pronunciation information for a word
    Loads from word_data.json if available

    Args:
        word: Word to look up

    Returns:
        Dict with syllables and IPA if available
    """
    try:
        import json
        from pathlib import Path

        # Load word data
        word_data_path = Path(__file__).parent / "utils" / "word_data.json"

        if word_data_path.exists():
            with open(word_data_path, "r") as f:
                word_data = json.load(f)

            if word in word_data:
                return word_data[word]

        # Return empty if not found
        return {"Syllables": word, "IPA": f"/{word}/"}

    except Exception as e:
        print(f"Error loading word info: {e}")
        return {"Syllables": word, "IPA": f"/{word}/"}
