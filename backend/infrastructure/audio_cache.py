"""
Audio Cache - Stores generated audio and challenge data in memory
"""

from typing import Dict, Optional

# In-memory caches
_challenge_cache: Dict[int, Dict] = {}
_audio_cache: Dict[tuple, bytes] = {}  # (challenge_id, option_letter) -> audio_bytes


def cache_challenge(challenge_id: int, challenge_data: Dict) -> None:
    """Cache challenge data"""
    _challenge_cache[challenge_id] = challenge_data
    print(f"📦 Cached challenge {challenge_id}")


def get_cached_challenge(challenge_id: int) -> Optional[Dict]:
    """Retrieve cached challenge data"""
    return _challenge_cache.get(challenge_id)


def cache_audio(challenge_id: int, option_letter: str, audio_bytes: bytes) -> None:
    """Cache audio data for a specific option"""
    key = (challenge_id, option_letter.upper())
    _audio_cache[key] = audio_bytes
    print(f"🎵 Cached audio for challenge {challenge_id}, option {option_letter}")


def get_cached_audio(challenge_id: int, option_letter: str) -> Optional[bytes]:
    """Retrieve cached audio data"""
    key = (challenge_id, option_letter.upper())
    audio = _audio_cache.get(key)

    if audio:
        print(
            f"🎵 Retrieved audio for challenge {challenge_id}, option {option_letter}: {len(audio)} bytes"
        )
    else:
        print(f"❌ No audio found for challenge {challenge_id}, option {option_letter}")
        print(f"   Available keys: {list(_audio_cache.keys())}")

    return audio


def clear_cache() -> None:
    """Clear all caches"""
    _challenge_cache.clear()
    _audio_cache.clear()
    print("🧹 Cache cleared")


def get_cache_stats() -> Dict:
    """Get cache statistics"""
    return {
        "challenges_cached": len(_challenge_cache),
        "audio_files_cached": len(_audio_cache),
    }
