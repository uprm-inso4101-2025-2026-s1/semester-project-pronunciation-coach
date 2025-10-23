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


def add_wrong_syllable_stress(word: str) -> str:
    """
    Add incorrect stress by inserting pauses in wrong places
    Example: "beautiful" -> "beau-TI-ful" (wrong stress on 'ti')
    """
    if len(word) <= 3:
        return word.upper()  # Just emphasize short words

    # Split roughly into thirds and capitalize middle
    third = len(word) // 3
    return f"{word[:third]} {word[third:third*2].upper()} {word[third*2:]}"


def mispronounce_vowels(word: str) -> str:
    """
    Change vowel sounds to create mispronunciation
    Example: "said" -> "sayed", "women" -> "wo-men"
    """
    mispronounced = word.lower()

    # Common vowel mispronunciations
    replacements = [
        ("ea", "ee-ah"),  # "bread" -> "bree-ahd"
        ("oo", "oh-oh"),  # "book" -> "boh-ohk"
        ("ou", "ow"),  # "could" -> "cowld"
        ("ai", "ay-eye"),  # "said" -> "say-eyed"
        ("ie", "eye-ee"),  # "friend" -> "fry-eend"
    ]

    for old, new in replacements:
        if old in mispronounced:
            mispronounced = mispronounced.replace(old, new, 1)
            return mispronounced

    # If no replacement made, insert dash in middle
    mid = len(word) // 2
    return f"{word[:mid]}-{word[mid:]}"


def add_extra_syllables(word: str) -> str:
    """
    Add extra syllables or repeat parts
    Example: "comfortable" -> "com-for-ta-ba-ble"
    """
    if len(word) <= 4:
        # Short words: repeat a syllable
        return f"{word[:2]}-{word[:2]}-{word[2:]}"

    # Longer words: add 'uh' sounds between consonant clusters
    result = []
    for i, char in enumerate(word):
        result.append(char)
        # Add 'uh' after consonants before vowels
        if i < len(word) - 1:
            if char not in "aeiou" and word[i + 1] not in "aeiou":
                result.append("-uh-")

    return "".join(result)


def spell_out_phonetically(word: str) -> str:
    """
    Spell out word letter by letter phonetically
    Example: "psychology" -> "pee ess why see aych oh ell oh gee why"
    """
    phonetic_alphabet = {
        "a": "ay",
        "b": "bee",
        "c": "see",
        "d": "dee",
        "e": "ee",
        "f": "eff",
        "g": "jee",
        "h": "aych",
        "i": "eye",
        "j": "jay",
        "k": "kay",
        "l": "ell",
        "m": "em",
        "n": "en",
        "o": "oh",
        "p": "pee",
        "q": "cue",
        "r": "are",
        "s": "ess",
        "t": "tee",
        "u": "you",
        "v": "vee",
        "w": "double-you",
        "x": "ecks",
        "y": "why",
        "z": "zee",
    }

    letters = [
        phonetic_alphabet.get(c.lower(), c) for c in word[:4]
    ]  # Only first 4 letters
    return " ".join(letters)


def generate_mispronunciations(word: str) -> List[str]:
    """
    Generate three DISTINCT mispronunciations for any word

    Args:
        word: The correct word

    Returns:
        List of 3 unique mispronounced versions
    """
    mispronunciations = []

    # Method 1: Wrong syllable stress
    misp1 = add_wrong_syllable_stress(word)
    mispronunciations.append(misp1)

    # Method 2: Wrong vowel sounds
    misp2 = mispronounce_vowels(word)
    # Make sure it's different from first
    if misp2 == misp1 or misp2 == word:
        misp2 = add_extra_syllables(word)
    mispronunciations.append(misp2)

    # Method 3: Phonetic spelling (only for longer words)
    if len(word) >= 5:
        misp3 = spell_out_phonetically(word)
    else:
        misp3 = add_extra_syllables(word)

    # Ensure uniqueness
    if misp3 in mispronunciations or misp3 == word:
        # Fallback: just add dashes
        misp3 = "-".join([word[i : i + 2] for i in range(0, len(word), 2)])

    mispronunciations.append(misp3)

    # Final check: ensure all are unique
    unique_misps = []
    for misp in mispronunciations:
        if misp not in unique_misps and misp != word:
            unique_misps.append(misp)

    # If we don't have 3 unique ones, create more variations
    while len(unique_misps) < 3:
        variation = f"{word[0].upper()}-{word[1:].lower()}"
        if variation not in unique_misps and variation != word:
            unique_misps.append(variation)
        else:
            # Last resort: add emphasis markers
            unique_misps.append(f"THE {word.upper()}")
            break

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
