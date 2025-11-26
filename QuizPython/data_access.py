from __future__ import annotations
import json
import os
import re
from typing import Dict, List, Optional

# Accessor for the local JSON word bank used by the quiz.

    # - The file 'QuizPython/wordbank.json' is generated OFFLINE from CMUdict
    #   (using the 'pronouncing' library) by 'tools/build_wordbank_offline.py'.
    # - ARPABET -> IPA conversion is done during the build step.
    # - No network is used at runtime.

# JSON format per entry:
# {
#   "hello": { # normalized word key
#     "ipa": "/həˈloʊ/", # IPA string
#     "syllables": ["hə","loʊ"],  # IPA syllables
#     "source": "cmudict-offline"    # optional source info
#   }
# }

# Expected file: QuizPython/wordbank.json

# ---- Internal cache ----

# Holds the entire word bank as a dictionary and keeps it in memory for the rest of the program.
_WORDS: Optional[Dict[str, Dict]] = None
_BANK_FILENAME = "wordbank.json"

def _bank_path() -> str:
    # Returns the absolute path to QuizPython/wordbank.json
    here = os.path.dirname(__file__)
    return os.path.join(here, _BANK_FILENAME)

def _load_bank() -> Dict[str, Dict]:
    # Loads the JSON once and keeps it in memory.
    global _WORDS
    if _WORDS is None: # Only loads if the JSON hasn't been loaded yet.
        path = _bank_path() # Finds the path to the word bank JSON file.
        if not os.path.exists(path):  
            raise FileNotFoundError( # File not found error if the file is missing.
                f"Word bank not found at {path}. "
                "Generate it with tools/build_wordbank_offline.py."
            )
        with open(path, "r", encoding="utf-8") as f: # Opens and reads the JSON file, storing it in _WORDS.
            _WORDS = json.load(f)
    return _WORDS # Returns the loaded word bank.

# ---- Public helpers the quiz will call ----
_PUNCT_EDGES = re.compile(r"^[^\w'-]+|[^\w'-]+$")  # Strips edges, keeps inner - and ' from user input so it matches the JSON keys.

def normalize(word: str) -> str:
    # Returns the normalized word. Lowercase, trim, and removed surrounding punctuation/spaces.
    w = word.strip().lower()
    return _PUNCT_EDGES.sub("", w)

def has_word(word: str) -> bool:
    # Return True if the word exists in the bank after normalization.
    return normalize(word) in _load_bank()

def get_entry(word: str) -> Optional[Dict]:
    # Returns the word's full entry dict or None.
    return _load_bank().get(normalize(word))

def get_ipa(word: str) -> Optional[str]:
    # Returns the word's IPA string or None if unknown.
    e = get_entry(word)
    return e.get("ipa") if e else None

def get_syllables(word: str) -> Optional[List[str]]:
    # Returns the list of word's syllables or None if unknown.
    e = get_entry(word)
    return e.get("syllables") if e else None

def available_words() -> List[str]:
    # Returns all normalized keys currently in the bank.
    return list(_load_bank().keys())

def reload_bank() -> None:
    # Force re-read of the JSON so it can be regenerated while the app is running (if necessary).
    global _WORDS
    _WORDS = None
    _load_bank()
