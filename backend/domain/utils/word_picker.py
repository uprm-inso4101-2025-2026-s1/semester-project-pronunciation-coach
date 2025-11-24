"""
Word Picker Utility
Original Author: uziellopez7
Moved from: QuizPython/Random_Word_Picker.py
Modified for: FastAPI backend integration
"""
"""
Modified by: iralys-sanchez18
Integrated with JSON word bank and word difficulty classifier.
"""

import random
from collections import Counter
from typing import List

from nltk.corpus import brown
from quiz_wordbank import data_access as wb
from domain.utils.word_difficulty import classify_word_difficulty

# Cache word list in memory so it's not reloaded every call
_WORD_CACHE: List[str] | None = None

# Difficulty buckets cache
_DIFFICULTY_BUCKETS: dict[str, list[str]] = {
    "easy": [],
    "medium": [],
    "hard": [],
}
_DIFFICULTY_READY: bool = False

def _load_words() -> List[str]:
    """
    Loads and caches words from the wordbank.

    Function by: iralys-sanchez18
    """
    global _WORD_CACHE

    if _WORD_CACHE is not None:
        return _WORD_CACHE

    try:
        words = wb.available_words()  # keys from wordbank.json
        # Keep words longer than 2 letters
        filtered = [w for w in words if len(w) >= 3]

        if not filtered:
            raise ValueError("Wordbank contained no words >= 3 characters")
    
        _WORD_CACHE = filtered if filtered else words
        print(f"Loaded {_WORD_CACHE.__len__()} filtered words from wordbank") # Debug log
    except Exception as e: 
        print(f"Error loading words from wordbank: {e}")
        _WORD_CACHE = [
            "hello",
            "world",
            "python",
            "computer",
            "programming",
            "developer",
            "software",
            "application",
            "database",
            "server",
        ]

    return _WORD_CACHE

_FREQUENCY_LIST = None

def _build_frequency_list():
    global _FREQUENCY_LIST
    if _FREQUENCY_LIST is not None:
        return _FREQUENCY_LIST

    print("[WordPicker] Building Brown frequency list…")

    # Only extracts words that are alphabetic and lowercase
    words = [w.lower() for w in brown.words() if w.isalpha()]

    # Counts frequencies
    freq = Counter(words)

    # Sorts by descending frequency
    _FREQUENCY_LIST = [w for w, _ in freq.most_common()]

    print(f"[WordPicker] Loaded {len(_FREQUENCY_LIST)} ranked words from Brown corpus")

    return _FREQUENCY_LIST

def _pick_easy_frequency_based(top_n: int = 2000) -> str:
    # Picks an easy word using real-world English frequency.
    # Takes the top-N most common words (default: 2000)
    # and picks one at random.

    freq_list = _build_frequency_list()

    # Limit size
    limit = min(top_n, len(freq_list))
    slice_top = freq_list[:limit]

    # Only chooses words that also exist in the wordbank
    wordbank = set(_load_words())
    candidates = [w for w in slice_top if w in wordbank]

    # If enough candidates exist, use them
    if len(candidates) > 200:
        return random.choice(candidates)

    # If scarce, fallback to the plain top slice
    if slice_top:
        print("[WordPicker] Few easy candidates, falling back to top-N slice.")
        return random.choice(slice_top)

    # Last fallback: complete word list
    return random.choice(list(wordbank))

def _build_difficulty_buckets() -> None:
    # Builds easy/medium/hard word lists from the cached wordbank.
    # Runs once per backend process.

    global _DIFFICULTY_BUCKETS, _DIFFICULTY_READY

    words = _load_words()
    buckets = {"easy": [], "medium": [], "hard": []}

    for w in words:
        level = classify_word_difficulty(w)  # "easy" / "medium" / "hard"
        if level not in buckets:
            level = "medium"
        buckets[level].append(w)

    _DIFFICULTY_BUCKETS = buckets
    _DIFFICULTY_READY = True

    total = sum(len(v) for v in buckets.values())
    print(
        f"[WordPicker] Difficulty buckets built: "
        f"easy={len(buckets['easy'])}, "
        f"medium={len(buckets['medium'])}, "
        f"hard={len(buckets['hard'])}, "
        f"total={total}"
    )

def get_random_english_word() -> str:
    """
    Returns a completely random English word from Brown corpus.
    Filters out words with symbols and words with 3 letters or less.

    Original function by: uziellopez7
    """
    # try:
    #     word_list = [w for w in brown.words() if (len(w) > 3) and (w.isalpha())]
    #     if not word_list:
    #         raise ValueError("Brown corpus is empty")
    #     return random.choice(word_list).lower()
    # except Exception as e:
    #     print(f"Error accessing Brown corpus: {e}")
    #     # Fallback to basic English words
    #     fallback_words = [
    #         "hello",
    #         "world",
    #         "python",
    #         "computer",
    #         "programming",
    #         "developer",
    #         "software",
    #         "application",
    #         "database",
    #         "server",
    #     ]
    #     return random.choice(fallback_words)

    # Modified by: iralys-sanchez18
    # Returns a random word from the filtered wordbank.

    """
    Unused. The difficulty system now uses classifier buckets.
    """

    words = _load_words()
    return random.choice(words)

def get_random_common_word(top_n: int = 1000) -> str:
    """
    Returns a random word from the top N most commonly used words.

    Args:
        top_n: Number of top common words to sample from (default: 1000)

    Returns:
        Random word from the top N most common words

    Original function by: uziellopez7
    """
    # try:
    #     frequency = Counter(w.lower() for w in brown.words() if w.isalpha())
    #     common_words = [w for w, c in frequency.most_common(top_n) if w.isalpha()]
    #     if not common_words:
    #         raise ValueError("No common words found")
    #     return random.choice(common_words)
    # except Exception as e:  # pylint: disable=broad-exception-caught
    #     print(f"Error getting common words: {e}")
    #     # Fallback to basic words
    #     return get_random_english_word()

    # Modified by: iralys-sanchez18
    # Since the wordbank has no data regarding frequency, this approximates
    # “common” by taking from the first 1000 words of the list.

    """
    Unused. The difficulty system now uses classifier buckets. The original function
    has been repurposed to create a frequency list instead.
    """

    words = _load_words()

    if len(words) <= top_n:
        pool = words
    else:
        pool = words[:top_n]

    return random.choice(pool)

def get_word_by_difficulty(difficulty: str) -> str:
    """
    Get a word based on difficulty level using word frequency.

    Args:
        difficulty: "easy" (top 100), "medium" (100-1000), "hard" (1000-5000)

    Returns:
        Random word matching difficulty

    Note: Built on top of get_random_common_word by uziellopez7
    """
    # ranges = {"easy": 100, "medium": 1000, "hard": 5000}

    # top_n = ranges.get(difficulty, 1000)
    # return get_random_common_word(top_n)

    # Modified by: iralys-sanchez18

    global _DIFFICULTY_READY

    # Ensures the difficulty buckets are built
    if not _DIFFICULTY_READY:
        _build_difficulty_buckets()

    diff = (difficulty or "").lower()

    # EASY -> frequency-based
    if diff == "easy":
        return _pick_easy_frequency_based(top_n=2000)

    # MEDIUM / HARD -> phonetic buckets
    bucket = _DIFFICULTY_BUCKETS.get(diff)
    
    if bucket:
        return random.choice(bucket)

    # fallback
    return random.choice(_load_words())