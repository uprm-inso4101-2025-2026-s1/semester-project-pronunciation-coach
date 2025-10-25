"""
Text-to-Speech Engine
Original Author: uziellopez7
Moved from: QuizPython/TTS.py
Modified for: FastAPI backend usage

Provides text-to-speech functionality using pyttsx3 (offline, cross-platform).
"""

import importlib
import subprocess
import sys
from typing import List, Optional


def _ensure_package(pkg_name: str) -> bool:
    """
    Auto-install package if missing.
    Original helper by: uziellopez7
    """
    try:
        importlib.import_module(pkg_name)
        return True
    except ImportError:
        try:
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install", pkg_name],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            importlib.invalidate_caches()
            importlib.import_module(pkg_name)
            return True
        except Exception:
            return False


def get_tts_engine(rate: int = 160, volume: float = 1.0):
    """
    Initialize pyttsx3 TTS engine.
    Works offline on Windows (SAPI5), macOS, and Linux.

    Original function by: uziellopez7

    Args:
        rate: Speech rate (words per minute)
        volume: Volume level (0.0 to 1.0)

    Returns:
        TTS engine instance or None if unavailable
    """
    if not _ensure_package("pyttsx3"):
        return None

    try:
        import pyttsx3

        engine = pyttsx3.init()
        engine.setProperty("rate", rate)
        engine.setProperty("volume", volume)
        return engine
    except Exception:
        return None


def speak_text(text: str, engine=None) -> bool:
    """
    Speak the given text using TTS.

    Args:
        text: Text to speak
        engine: Pre-initialized TTS engine (or None to create new)

    Returns:
        True if successful, False otherwise
    """
    if engine is None:
        engine = get_tts_engine()

    if engine is None:
        return False

    try:
        engine.say(text)
        engine.runAndWait()
        return True
    except Exception:
        return False


def speak_word_list(words: List[str], engine=None, boost: int = 1) -> None:
    """
    Speak multiple words with pauses.

    Original function by: uziellopez7
    Modified to accept list of strings directly.

    Args:
        words: List of words to speak
        engine: TTS engine instance
        boost: Number of times to repeat each word
    """
    if engine is None:
        engine = get_tts_engine()

    if engine is None:
        return

    try:
        for word in words:
            for _ in range(max(1, boost)):
                engine.say(word)
            engine.runAndWait()
    except Exception:
        pass


# Keep original function name for compatibility
def TTS_Speak(words: List[str], engine=None) -> None:
    """
    Original function signature from TTS.py.

    Original function by: uziellopez7
    """
    speak_word_list(words, engine)
