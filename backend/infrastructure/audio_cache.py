"""
Audio Cache - In-memory storage for audio challenges
In production, this would use Redis or database storage
"""

import io
from typing import Dict, Optional

# In-memory cache for challenges
_challenge_cache: Dict[int, Dict] = {}

# In-memory cache for audio files
_audio_cache: Dict[str, bytes] = {}


def cache_challenge(challenge_id: int, challenge_data: Dict) -> None:
    """
    Cache a challenge for later retrieval

    Args:
        challenge_id: Unique challenge ID
        challenge_data: Challenge data dict
    """
    _challenge_cache[challenge_id] = challenge_data


def get_cached_challenge(challenge_id: int) -> Optional[Dict]:
    """
    Retrieve a cached challenge

    Args:
        challenge_id: Challenge ID to retrieve

    Returns:
        Challenge data dict or None if not found
    """
    return _challenge_cache.get(challenge_id)


def cache_audio(key: str, audio_data: bytes) -> None:
    """
    Cache audio data

    Args:
        key: Cache key (e.g., "challenge_123_option_A")
        audio_data: Audio bytes
    """
    _audio_cache[key] = audio_data


def get_cached_audio(challenge_id: int, option_letter: str) -> Optional[bytes]:
    """
    Retrieve cached audio data

    Args:
        challenge_id: Challenge ID
        option_letter: Option letter (A, B, C, D)

    Returns:
        Audio bytes or None if not found
    """
    key = f"challenge_{challenge_id}_option_{option_letter}"

    if key in _audio_cache:
        return _audio_cache[key]

    # Generate audio on demand if not cached
    challenge = get_cached_challenge(challenge_id)
    if challenge is None:
        return None

    # Find the variant for this option
    option_index = ord(option_letter.upper()) - 65  # A=0, B=1, C=2, D=3

    if option_index < 0 or option_index >= len(challenge["variants"]):
        return None

    variant = challenge["variants"][option_index]
    word = challenge["word"]
    pattern = variant["pattern"]

    # Generate audio
    from domain.audio_challenge_logic import generate_audio_for_word

    audio_bytes = generate_audio_for_word(word, pattern, format="bytes")

    # Cache it
    cache_audio(key, audio_bytes)

    return audio_bytes


def clear_cache() -> None:
    """Clear all cached data"""
    _challenge_cache.clear()
    _audio_cache.clear()


def get_cache_stats() -> Dict:
    """Get cache statistics"""
    return {
        "challenges_cached": len(_challenge_cache),
        "audio_files_cached": len(_audio_cache),
        "total_audio_size_mb": sum(len(data) for data in _audio_cache.values())
        / (1024 * 1024),
    }
