"""
Audio Challenge Logic - Business logic for TTS pronunciation challenges.
Handles word selection, mispronunciation generation, and TTS audio creation.
"""

import base64
import io
import random
from typing import Dict, List

from domain.utils.word_picker import get_word_by_difficulty
from gtts import gTTS

# Vowel-focused Mispronunciation Techniques


def elongate_vowel(word: str) -> str:
    """
    Elongate a random vowel to create a drawn-out pronunciation.
    Example: "me" -> "meeee"
    """
    vowels = "aeiouAEIOU"
    result = []
    vowel_indices = [i for i, char in enumerate(word) if char in vowels]

    if not vowel_indices:
        return word  # No vowels to elongate

    # Pick a random vowel to elongate
    elongate_index = random.choice(vowel_indices)

    for i, char in enumerate(word):
        result.append(char)
        if i == elongate_index:
            # Add 2-3 extra of the same vowel
            result.append(char * random.randint(2, 3))

    return "".join(result)


def replace_vowel_with_similar(word: str) -> str:
    """
    Replace a vowel with a similar-sounding one to create mispronunciation.
    Example: "me" -> "mi"
    """
    vowel_replacements = {
        "e": "i",
        "i": "e",
        "a": "o",
        "o": "a",
        "u": "o",
        # Capital letters for consistency
        "E": "I",
        "I": "E",
        "A": "O",
        "O": "A",
        "U": "O",
    }

    vowels = "aeiouAEIOU"
    vowel_indices = [i for i, char in enumerate(word) if char in vowels]

    if not vowel_indices:
        return word  # No vowels to replace

    # Pick a random vowel to replace
    replace_index = random.choice(vowel_indices)
    original_char = word[replace_index]

    if original_char in vowel_replacements:
        replacement_char = vowel_replacements[original_char]
        return word[:replace_index] + replacement_char + word[replace_index + 1 :]

    return word


def add_aspirated_vowel(word: str) -> str:
    """
    Add an 'h' after a vowel to create an aspirated or different sound.
    Example: "me" -> "meh"
    """
    vowels = "aeiouAEIOU"
    vowel_indices = [i for i, char in enumerate(word) if char in vowels]

    if not vowel_indices:
        return word  # No vowels to modify

    # Pick a random vowel to aspirate
    aspirate_index = random.choice(vowel_indices)

    return word[: aspirate_index + 1] + "h" + word[aspirate_index + 1 :]


def create_pronunciation_variants(word: str) -> List[Dict[str, str]]:
    """
    Create pronunciation variants: 1 correct, 3 unique wrong.
    """
    variants = []
    used_pronunciations = {word.lower()}  # Track to ensure uniqueness

    # Correct pronunciation
    variants.append(
        {"word": word, "spoken_text": word, "type": "correct", "pattern": "correct"}
    )

    # List of mispronunciation techniques
    techniques = [
        ("elongate_vowel", elongate_vowel),
        ("replace_vowel", replace_vowel_with_similar),
        ("aspirated_vowel", add_aspirated_vowel),
    ]

    # Generate 3 unique mispronunciations
    wrong_count = 0
    technique_idx = 0
    max_attempts = 10  # Safety break

    while wrong_count < 3 and max_attempts > 0:
        max_attempts -= 1

        # Cycle through techniques
        technique_name, technique_func = techniques[technique_idx % len(techniques)]
        technique_idx += 1

        misp = technique_func(word)

        # Normalize for comparison (remove punctuation and spaces)
        normalized = misp.replace(",", "").replace("-", "").replace(" ", "").lower()

        # Check if unique and not the original word
        if normalized not in used_pronunciations and normalized != word.lower().replace(
            " ", ""
        ):
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
        elif misp != word:
            # If it's a duplicate of a WRONG one, log it but continue
            pass

    # Shuffle options to randomize correct answer position
    random.shuffle(variants)

    # Ensure exactly 4 options by adding simple fallbacks if needed (unlikely)
    while len(variants) < 4:
        # Simple fallback: capitalize first letter
        fallback = f"{word[0].upper()}{word[1:].lower()}"
        if fallback.lower().replace(" ", "") not in used_pronunciations:
            variants.append(
                {
                    "word": word,
                    "spoken_text": fallback,
                    "type": f"wrong_{len(variants)}",
                    "pattern": "fallback",
                }
            )
            used_pronunciations.add(fallback.lower().replace(" ", ""))
        else:
            # Final resort, unlikely to conflict
            variants.append(
                {
                    "word": word,
                    "spoken_text": f"The {word.lower()}",
                    "type": f"wrong_{len(variants)}",
                    "pattern": "fallback_final",
                }
            )

    return variants[:4]  # Return exactly 4


def generate_audio_for_variant(variant: Dict, format: str = "bytes") -> bytes:
    """
    Generate audio for a pronunciation variant using Google TTS.
    """
    try:
        spoken_text = variant["spoken_text"]
        pattern = variant["pattern"]

        # Use slow speech for elongated/aspirated versions for a more noticeable effect
        is_slow = (
            pattern in ["elongate_vowel", "aspirated_vowel"] and random.random() > 0.5
        )

        tts = gTTS(text=spoken_text, lang="en", slow=is_slow, lang_check=False)

        audio_fp = io.BytesIO()
        tts.write_to_fp(audio_fp)

        audio_fp.seek(0)
        audio_bytes = audio_fp.read()

        if format == "base64":
            return base64.b64encode(audio_bytes).decode("utf-8")
        else:
            return audio_bytes

    except Exception:
        # Return empty audio data on failure
        if format == "base64":
            return ""
        else:
            return b""


def generate_audio_challenge(difficulty: str) -> Dict:
    """
    Generate a complete audio challenge.
    """
    # Get random word based on difficulty
    word = get_word_by_difficulty(difficulty)

    # Get pronunciation variants (1 correct + 3 wrong)
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

        # Generate audio
        audio_bytes = generate_audio_for_variant(variant, format="bytes")

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

    return {
        "id": challenge_id,
        "word": word,
        "difficulty": difficulty,
        "content": f"Which pronunciation of '{word}' is correct?",
        "type": "audio_pronunciation",
        "xp_reward": xp_map[difficulty],
        "hint": f"Listen carefully to the vowel sounds.",
        "options": options_data,
        "correct_answer": correct_letter,
    }
