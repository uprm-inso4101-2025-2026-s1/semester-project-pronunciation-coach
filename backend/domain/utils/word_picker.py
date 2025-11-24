"""
Word Picker Utility
Original Author: uziellopez7
Moved from: QuizPython/Random_Word_Picker.py
Modified for: FastAPI backend integration
"""
"""
Modified by: iralys-sanchez18
Replaces NLTK Brown corpus with 57k-word JSON wordbank.
"""

import random
# import ssl
from collections import Counter
from typing import List
from quiz_wordbank import data_access as wb

# import nltk
# from nltk.corpus import brown

# # SSL workaround for macOS
# try:
#     _create_unverified_https_context = ssl._create_unverified_context
# except AttributeError:
#     pass
# else:
#     ssl._create_default_https_context = _create_unverified_https_context

# Cache word list in memory so it's not reloaded every call
_WORD_CACHE: List[str] | None = None

def _load_words() -> List[str]:
    """
    Load and cache words from the wordbank.

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

# Download required NLTK data (run once)
# def _ensure_brown_corpus():
#     """Ensure Brown corpus is downloaded"""
#     try:
#         nltk.data.find("corpora/brown")
#         return True
#     except LookupError:
#         try:
#             print("Downloading NLTK Brown corpus (first time only)...")
#             nltk.download("brown", quiet=True)
#             return True
#         except Exception as e:
#             print(f"Error downloading Brown corpus: {e}")
#             print("Please run: python3 download_nltk_data.py")
#             return False


# Initialize corpus on module import
# _ensure_brown_corpus()


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

    # Difficulty ranges:
    # - easy   = first 100 filtered words
    # - medium = first 1000 filtered words
    # - hard   = first 5000 filtered words

    words = _load_words()
    
    ranges = {"easy": 100, "medium": 1000, "hard": 5000}
    top_n = ranges.get(difficulty, 1000)

    pool_size = min(top_n, len(words))
    pool = words[:pool_size]

    print(
    f"[WordPicker] Ready: {len(words)} words loaded, "
    f"difficulty={difficulty}, pool_size={pool_size}"
    ) # Debug log

    return random.choice(pool)