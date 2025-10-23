"""
Audio Cache - In-memory storage for audio challenges and audio data
"""

from typing import Dict, Optional

# In-memory cache for audio data
_audio_cache: Dict[str, bytes] = {}
_challenge_cache: Dict[int, Dict] = {}


def cache_audio(challenge_id: int, option_letter: str, audio_bytes: bytes) -> None:
    """
    Cache audio data for a challenge option

    Args:
        challenge_id: Challenge ID
        option_letter: Option letter (A, B, C, D)
        audio_bytes: Audio data as bytes
    """
    cache_key = f"{challenge_id}_{option_letter}"
    _audio_cache[cache_key] = audio_bytes
    print(f"  💾 Cached audio for {cache_key} ({len(audio_bytes)} bytes)")


def cache_challenge(challenge_id: int, data: Dict) -> None:
    """
    Cache challenge data

    Args:
        challenge_id: Challenge ID
        data: Challenge data dictionary
    """
    _challenge_cache[challenge_id] = data
    print(f"  💾 Cached challenge {challenge_id}")


def get_cached_audio(challenge_id: int, option_letter: str) -> Optional[bytes]:
    """
    Retrieve cached audio

    Args:
        challenge_id: Challenge ID
        option_letter: Option letter (A, B, C, D)

    Returns:
        Audio bytes or None if not found
    """
    cache_key = f"{challenge_id}_{option_letter}"
    audio_data = _audio_cache.get(cache_key)

    if audio_data:
        print(f"  ✅ Retrieved cached audio for {cache_key}")
    else:
        print(f"  ❌ No cached audio found for {cache_key}")

    return audio_data


def get_cached_challenge(challenge_id: int) -> Optional[Dict]:
    """
    Retrieve cached challenge data

    Args:
        challenge_id: Challenge ID

    Returns:
        Challenge data dictionary or None if not found
    """
    challenge_data = _challenge_cache.get(challenge_id)

    if challenge_data:
        print(f"  ✅ Retrieved cached challenge {challenge_id}")
    else:
        print(f"  ❌ No cached challenge found for {challenge_id}")

    return challenge_data


def clear_audio_cache() -> None:
    """
    Clear all cached audio data
    """
    _audio_cache.clear()
    print("  🗑️  Cleared audio cache")


def clear_challenge_cache() -> None:
    """
    Clear all cached challenge data
    """
    _challenge_cache.clear()
    print("  🗑️  Cleared challenge cache")


def clear_all_caches() -> None:
    """
    Clear all caches (audio and challenge)
    """
    clear_audio_cache()
    clear_challenge_cache()
    print("  🗑️  Cleared all caches")


def get_cache_stats() -> Dict:
    """
    Get statistics about cached data

    Returns:
        Dict with cache statistics
    """
    total_audio_size = sum(len(audio) for audio in _audio_cache.values())

    return {
        "audio_entries": len(_audio_cache),
        "challenge_entries": len(_challenge_cache),
        "total_audio_bytes": total_audio_size,
        "total_audio_mb": round(total_audio_size / (1024 * 1024), 2),
    }
