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


def add_syllable_breaks(word: str) -> str:
    """
    Add spaces between syllables to create mispronunciation
    Example: "comfortable" -> "com for ta ble"
    """
    # Insert spaces before vowel groups
    syllabified = re.sub(r"([aeiou]+)", r" \1 ", word)
    # Clean up extra spaces
    syllabified = " ".join(syllabified.split())
    return syllabified


def emphasize_silent_letters(word: str) -> str:
    """
    Pronounce normally silent letters
    Example: "knife" -> "k-nife", "psychology" -> "p-sigh-kology"
    """
    # Common silent letter patterns
    mispronounced = word

    # Silent K before N
    if word.startswith("kn"):
        mispronounced = "k-" + word[1:]

    # Silent P before S
    if word.startswith("ps"):
        mispronounced = "p-" + word[1:]

    # Silent G before N
    if word.startswith("gn"):
        mispronounced = "g-" + word[1:]

    # Silent W before R
    if word.startswith("wr"):
        mispronounced = "w-" + word[1:]

    # Silent B after M
    if "mb" in word:
        mispronounced = word.replace("mb", "m-b")

    # Silent GH
    if "gh" in word and not word.endswith("gh"):
        mispronounced = word.replace("gh", "g-h")

    return mispronounced


def phonetic_spelling(word: str) -> str:
    """
    Convert word to phonetic spelling for mispronunciation
    Makes it sound more "spelled out"
    """
    # Common phonetic substitutions for mispronunciation
    phonetic = word.lower()

    # Make it sound more literal
    phonetic = phonetic.replace("tion", "shun")
    phonetic = phonetic.replace("ture", "chur")
    phonetic = phonetic.replace("ough", "off")
    phonetic = phonetic.replace("augh", "aw")
    phonetic = phonetic.replace("eigh", "ay")

    # Split into syllable-like chunks
    chunks = []
    i = 0
    while i < len(phonetic):
        if i < len(phonetic) - 1:
            chunks.append(phonetic[i : i + 2])
            i += 2
        else:
            chunks.append(phonetic[i])
            i += 1

    return "-".join(chunks)


def reverse_stress_pattern(word: str) -> str:
    """
    Change stress pattern by repeating different parts
    Example: "comfortable" -> "com-fort-able" with emphasis on wrong syllable
    """
    # If word has multiple syllables, emphasize the wrong one
    if len(word) > 6:
        mid = len(word) // 2
        return word[:mid] + "-" + word[mid:].upper()
    elif len(word) > 3:
        # Emphasize first syllable incorrectly
        return word[:3].upper() + "-" + word[3:]
    else:
        # Short word - just repeat it
        return word + " " + word


def generate_mispronunciations(word: str) -> List[str]:
    """
    Generate three different mispronunciations for any word

    Args:
        word: The correct word

    Returns:
        List of 3 mispronounced versions
    """
    mispronunciations = []

    # Method 1: Over-syllabify (spell it out too much)
    mispronunciations.append(add_syllable_breaks(word))

    # Method 2: Pronounce silent letters
    mispronunciations.append(emphasize_silent_letters(word))

    # Method 3: Phonetic/literal spelling
    mispronunciations.append(phonetic_spelling(word))

    # If any are the same as original, use reverse stress
    for i in range(len(mispronunciations)):
        if mispronunciations[i] == word or mispronunciations[i] == mispronunciations[0]:
            mispronunciations[i] = reverse_stress_pattern(word)

    return mispronunciations[:3]


def get_pronunciation_variants(word: str) -> List[Dict[str, str]]:
    """
    Get pronunciation variants for a word - automatically generated
    """
    variants = []

    # Correct pronunciation
    variants.append(
        {"word": word, "spoken_text": word, "type": "correct", "pattern": "correct"}
    )

    # Generate three mispronunciations
    mispronunciations = generate_mispronunciations(word)

    for i, misp in enumerate(mispronunciations):
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

        # Use slow speech for emphasized pronunciations
        is_slow = "wrong" in pattern and random.random() > 0.5

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
    for v in variants:
        print(f"   📝 {v['type']}: '{v['spoken_text']}'")

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

    print(f"✅ Challenge {challenge_id} generated successfully!")

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
