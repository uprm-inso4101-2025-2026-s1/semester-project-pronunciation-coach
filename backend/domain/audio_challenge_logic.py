"""
Audio Challenge Logic - Business logic for TTS pronunciation challenges
Improved with natural mispronunciations
"""

import base64
import io
import random
from typing import Dict, List

from domain.utils.word_picker import get_word_by_difficulty
from gtts import gTTS


def create_elongated_pronunciation(word: str) -> str:
    """
    Elongate vowels to create drawn-out pronunciation
    Example: "beautiful" -> "beauuutiful"
    """
    vowels = "aeiouAEIOU"
    result = []

    for i, char in enumerate(word):
        result.append(char)
        # Elongate random vowels (but not all)
        if char in vowels and random.random() > 0.5 and i < len(word) - 1:
            # Add 2-3 extra vowels
            result.append(char * random.randint(2, 3))

    elongated = "".join(result)
    print(f"      Elongated: '{word}' -> '{elongated}'")
    return elongated


def add_random_pauses(word: str) -> str:
    """
    Add pauses (commas) at random syllable boundaries
    Example: "computer" -> "comp, uter" or "compu, ter"
    """
    if len(word) <= 3:
        # For short words, just add one pause in middle
        mid = len(word) // 2
        result = f"{word[:mid]}, {word[mid:]}"
    else:
        # For longer words, add 1-2 pauses
        num_pauses = random.randint(1, 2)
        positions = sorted(
            random.sample(range(2, len(word) - 1), min(num_pauses, len(word) - 3))
        )

        result_parts = []
        last_pos = 0
        for pos in positions:
            result_parts.append(word[last_pos:pos])
            last_pos = pos
        result_parts.append(word[last_pos:])

        result = ", ".join(result_parts)

    print(f"      With pauses: '{word}' -> '{result}'")
    return result


def emphasize_wrong_syllable(word: str) -> str:
    """
    Emphasize the wrong part of the word by capitalizing it
    Example: "computer" -> "comPUter" or "COMputer"
    """
    if len(word) <= 3:
        # Short words: emphasize first or last
        if random.random() > 0.5:
            result = word[0].upper() + word[1:].lower()
        else:
            result = word[:-1].lower() + word[-1].upper()
    else:
        # Longer words: emphasize a random section
        # Divide word into thirds
        third = len(word) // 3
        sections = [word[:third], word[third : third * 2], word[third * 2 :]]

        # Pick random section to emphasize (not first, as that's often correct)
        emphasize_idx = random.randint(1, 2)
        sections[emphasize_idx] = sections[emphasize_idx].upper()

        result = "".join(sections)

    print(f"      Wrong emphasis: '{word}' -> '{result}'")
    return result


def add_stutter(word: str) -> str:
    """
    Add stuttering effect by repeating first syllable or letter
    Example: "beautiful" -> "be-be-beautiful"
    """
    if len(word) <= 2:
        # Very short: repeat first letter
        result = f"{word[0]}-{word[0]}-{word}"
    elif len(word) <= 4:
        # Short: repeat first 2 letters
        result = f"{word[:2]}-{word[:2]}-{word}"
    else:
        # Longer: repeat first syllable (roughly first 2-3 letters)
        syllable_len = random.randint(2, 3)
        result = f"{word[:syllable_len]}-{word[:syllable_len]}-{word}"

    print(f"      Stutter: '{word}' -> '{result}'")
    return result


def mispronounce_consonants(word: str) -> str:
    """
    Replace or duplicate consonants for mispronunciation
    Example: "think" -> "tink" or "think-k"
    """
    # Common consonant swaps that sound different
    swaps = {
        "th": "t",
        "ch": "sh",
        "ph": "f",
        "gh": "g",
        "ck": "k",
    }

    result = word.lower()

    # Try to find and replace a consonant cluster
    for old, new in swaps.items():
        if old in result:
            result = result.replace(old, new, 1)
            print(f"      Consonant swap: '{word}' -> '{result}'")
            return result

    # If no cluster found, duplicate a random consonant
    consonants = [i for i, c in enumerate(word) if c.lower() not in "aeiou"]
    if consonants:
        pos = random.choice(consonants)
        result = word[: pos + 1] + word[pos] + word[pos + 1 :]
        print(f"      Doubled consonant: '{word}' -> '{result}'")
        return result

    return word


def create_pronunciation_variants(word: str) -> List[Dict[str, str]]:
    """
    Create pronunciation variants for a word with NATURAL mispronunciations
    Ensures all 3 wrong options are unique and different

    Args:
        word: The correct word

    Returns:
        List of dicts with 'word', 'spoken_text', 'type', and 'pattern'
    """
    print(f"\n  🔧 Creating variants for: '{word}'")

    variants = []
    used_pronunciations = {word.lower()}  # Track to ensure uniqueness

    # Correct pronunciation (always first, will be shuffled later)
    variants.append(
        {"word": word, "spoken_text": word, "type": "correct", "pattern": "correct"}
    )

    # List of mispronunciation techniques
    techniques = [
        ("elongated", create_elongated_pronunciation),
        ("paused", add_random_pauses),
        ("wrong_stress", emphasize_wrong_syllable),
        ("stutter", add_stutter),
        ("consonant_change", mispronounce_consonants),
    ]

    # Shuffle techniques to get random order
    random.shuffle(techniques)

    # Generate 3 unique mispronunciations
    wrong_count = 0
    technique_idx = 0
    max_attempts = 10  # Prevent infinite loops
    attempts = 0

    while wrong_count < 3 and attempts < max_attempts:
        attempts += 1

        # Get next technique
        technique_name, technique_func = techniques[technique_idx % len(techniques)]
        technique_idx += 1

        # Generate mispronunciation
        print(f"    🎲 Trying technique: {technique_name}")
        misp = technique_func(word)

        # Normalize for comparison (remove punctuation and spaces)
        normalized = misp.replace(",", "").replace("-", "").replace(" ", "").lower()

        # Check if unique
        if normalized not in used_pronunciations:
            used_pronunciations.add(normalized)
            variants.append(
                {
                    "word": word,
                    "spoken_text": misp,
                    "type": f"wrong_{wrong_count + 1}",
                    "pattern": technique_name,
                }
            )
            wrong_count += 1
            print(f"    ✅ Added variant #{wrong_count}: '{misp}'")
        else:
            print(f"    ❌ Duplicate, trying next technique")

    # If we somehow don't have 3 wrong ones (very unlikely), add fallbacks
    while len(variants) < 4:
        fallback = f"{word[0].upper()}, {word[1:].lower()}, {word[-1].upper()}"
        variants.append(
            {
                "word": word,
                "spoken_text": fallback,
                "type": f"wrong_{len(variants)}",
                "pattern": "fallback",
            }
        )
        print(f"    ⚠️  Added fallback variant: '{fallback}'")

    # Shuffle so correct answer isn't always in same position
    random.shuffle(variants)

    print(f"\n  ✨ Final variants:")
    for i, v in enumerate(variants):
        letter = chr(65 + i)  # A, B, C, D
        status = "✓ CORRECT" if v["type"] == "correct" else "✗ wrong"
        print(f"    {letter}: {status:12} | '{v['spoken_text']}'")
    print()

    return variants


def generate_audio_for_variant(variant: Dict, format: str = "bytes") -> bytes:
    """
    Generate audio for a pronunciation variant using Google TTS

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

        # For natural pronunciation, use slow speech sometimes
        # Especially for elongated or paused versions
        is_slow = (
            pattern in ["elongated", "paused", "stutter"] and random.random() > 0.5
        )

        if is_slow:
            print(f"      ⏱️  Using slow speech for more natural effect")

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

    print(f"\n{'='*60}")
    print(
        f"🎯 Generating audio challenge for word: '{word}' (difficulty: {difficulty})"
    )
    print(f"{'='*60}")

    # Get pronunciation variants (automatically generated with natural mispronunciations)
    variants = create_pronunciation_variants(word)

    # Verify we have exactly 4 variants (1 correct + 3 wrong)
    if len(variants) != 4:
        print(f"⚠️  WARNING: Expected 4 variants, got {len(variants)}")

    # Verify all are unique
    spoken_texts = [v["spoken_text"] for v in variants]
    unique_count = len(
        set(
            t.replace(",", "").replace("-", "").replace(" ", "").lower()
            for t in spoken_texts
        )
    )
    print(f"📊 Uniqueness check: {unique_count}/4 variants are unique")

    # Find correct answer position
    correct_index = next(i for i, v in enumerate(variants) if v["type"] == "correct")
    correct_letter = chr(65 + correct_index)  # A, B, C, D

    print(f"✓ Correct answer is at position: {correct_letter}")

    # Generate challenge ID
    challenge_id = random.randint(10000, 99999)

    # Generate and cache audio for each variant
    from infrastructure.audio_cache import cache_audio, cache_challenge

    print(f"\n🎵 Generating audio files...")
    options_data = []
    for i, variant in enumerate(variants):
        option_letter = chr(65 + i)

        # Generate audio for this variant
        print(f"\n  [{option_letter}] Generating audio (type: {variant['type']})")
        audio_bytes = generate_audio_for_variant(variant, format="bytes")

        # Debug: Check if audio was generated
        if audio_bytes:
            print(f"      ✅ Success: {len(audio_bytes)} bytes")
        else:
            print(f"      ⚠️  Warning: No audio data generated!")

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

    print(f"\n{'='*60}")
    print(f"✅ Challenge {challenge_id} generated successfully!")
    print(f"   Word: {word}")
    print(f"   Correct answer: {correct_letter}")
    print(f"   XP reward: {xp_map[difficulty]}")
    print(f"{'='*60}\n")

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
