"""
Audio Challenge Logic - Business logic for TTS pronunciation challenges
"""

import base64
import io
import random
from typing import Dict, List, Tuple

from domain.utils.word_picker import get_word_by_difficulty
from gtts import gTTS


def create_pronunciation_variants(word: str) -> List[Dict[str, str]]:
    """
    Create pronunciation variants for a word
    Returns list of variants with type and pronunciation pattern

    Args:
        word: The correct word

    Returns:
        List of dicts with 'word', 'type', and 'pattern'
    """
    variants = []

    # Correct pronunciation
    variants.append({"word": word, "type": "correct", "pattern": "normal"})

    # Variant 1: Stress on wrong syllable
    variants.append(
        {"word": word, "type": "wrong_stress", "pattern": "emphasized_first"}
    )

    # Variant 2: Different rate (too fast)
    variants.append({"word": word, "type": "wrong_rate", "pattern": "fast"})

    # Variant 3: Different rate (too slow)
    variants.append({"word": word, "type": "wrong_rate_slow", "pattern": "slow"})

    # Shuffle and return 4 options
    random.shuffle(variants)
    return variants


def generate_audio_for_word(
    word: str, pattern: str = "normal", format: str = "bytes"
) -> bytes:
    """
    Generate audio for a word using Google TTS (gTTS)

    Args:
        word: Word to pronounce
        pattern: Pronunciation pattern (normal, fast, slow, emphasized_first)
        format: Output format ('base64' or 'bytes')

    Returns:
        Audio bytes (MP3 format)
    """
    try:
        print(f"    🔊 Generating TTS for word: '{word}', pattern: '{pattern}'")

        # Determine which word/text to use
        text_to_speak = word
        is_slow = False

        if pattern == "slow":
            is_slow = True
            print(f"    ⏱️  Using slow speech")
        elif pattern == "emphasized_first":
            # Add emphasis by capitalizing
            text_to_speak = (
                word[0].upper() + word[1:].lower() if len(word) > 1 else word.upper()
            )
            print(f"    💪 Emphasizing: '{text_to_speak}'")
        elif pattern == "fast":
            # Normal speed for fast (gTTS limitation)
            print(f"    ⚡ Using normal speed (fast not directly supported)")

        # Create TTS object
        tts = gTTS(text=text_to_speak, lang="en", slow=is_slow, lang_check=False)

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

    # Generate pronunciation variants
    variants = create_pronunciation_variants(word)

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
            f"  🎵 Generating audio for option {option_letter} (pattern: {variant['pattern']})"
        )
        audio_bytes = generate_audio_for_word(word, variant["pattern"], format="bytes")

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

    print(f"✅ Challenge {challenge_id} generated successfully!")

    return {
        "id": challenge_id,
        "word": word,
        "difficulty": difficulty,
        "content": f"Which pronunciation of '{word}' is correct?",
        "type": "audio_pronunciation",
        "xp_reward": xp_map[difficulty],
        "hint": f"Listen carefully to the stress and rhythm",
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
