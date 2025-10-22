#!/usr/bin/env python3
"""
Random English word picker + TTS (Windows-friendly, works offline)

- Tries the `wordfreq` module first (auto-installs if missing).
- Falls back to NLTK's `words` corpus (auto-downloads 'words' if NLTK is present).
- Finally, uses a tiny built-in list.
- Picks N random words (default 1), prints them, and speaks them via pyttsx3.
- If pyttsx3 isn't installed, it will try to pip-install automatically.

Usage:
    python random_word_tts.py [N]
"""

import sys
import random
import importlib
import subprocess
from Random_Word_Picker import *

# ---------------------------
# Package helpers
# ---------------------------
def _ensure_package(pkg_name: str) -> bool:
    """Try to import; if missing, pip-install and try again. Returns True if importable."""
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

# ---------------------------
# Word sources
# ---------------------------
def _load_words_wordfreq(limit: int = 50000):
    """Load common English words using `wordfreq`."""
    from wordfreq import top_n_list
    return top_n_list("en", n_top=limit)

def _load_words_nltk():
    """Load words from NLTK's 'words' corpus, attempting a quiet download if needed."""
    import nltk
    try:
        from nltk.corpus import words as nltk_words
    except LookupError:
        try:
            nltk.download("words", quiet=True)
            from nltk.corpus import words as nltk_words
        except Exception:
            return []
    try:
        return list({w.lower() for w in nltk_words.words() if w.isalpha()})
    except Exception:
        return []

def get_word_source():
    """
    Decide which source to use and return (words, source_label).
    Priority: wordfreq -> nltk -> built-in.
    """
    if _ensure_package("wordfreq"):
        try:
            words = _load_words_wordfreq(limit=50000)
            if words:
                return words, "wordfreq (top 50k)"
        except Exception:
            pass

    if _ensure_package("nltk"):
        words = _load_words_nltk()
        if words:
            return words, "NLTK words corpus"



def pick_random_words(n: int = 1):
    words, source = get_word_source()
    chosen = [random.choice(words) for _ in range(max(1, n))]
    return chosen, source

# ---------------------------
# TTS
# ---------------------------
def get_tts_engine(rate: int = 160, volume: float = 1.0):
    """
    Initialize pyttsx3 engine. Returns None if unavailable.
    On Windows, pyttsx3 uses SAPI5 and works offline.
    """
    if not _ensure_package("pyttsx3"):
        return None
    try:
        import pyttsx3
        eng = pyttsx3.init()  # on Windows this should use the SAPI5 driver
        eng.setProperty("rate", rate)
        eng.setProperty("volume", volume)
        return eng
    except Exception:
        return None

def speak_words(words, engine=None, boost: int = 1):
    """
    Speak each word with a brief pause. If engine is None, do nothing.
    boost>1 repeats the spoken word multiple times for clarity.
    """
    if engine is None:
        return
    try:
        for w in words:
            # Say the word itself; you can add "The word is ..." if preferred.
            for _ in range(max(1, boost)):
                engine.say(w)
            engine.runAndWait()
    except Exception:
        # Fail silently if TTS breaks mid-run
        pass

# ---------------------------
# CLI
# ---------------------------
def TTS_Speak(word):
    try:
        n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    except ValueError:
        n = 1

    #chosen, source = pick_random_words(n)
    #print(chosen)
    # Print each on its own line
    #for w in chosen:
        #print(chosen)
        #print(w)

    # Speak them
    engine = get_tts_engine(rate=155, volume=1.0)
    speak_words(word, engine=engine, boost=1)
    # If you want to see the source, uncomment:
    # print(f"(source: {source})", file=sys.stderr)

#if __name__ == "__main__":

