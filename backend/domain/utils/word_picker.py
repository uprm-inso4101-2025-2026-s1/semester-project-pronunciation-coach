"""
Word Picker Utility
Original Author: uziellopez7
Moved from: QuizPython/Random_Word_Picker.py
Modified for: FastAPI backend integration

This module provides functions to select random English words
from the Brown corpus with various filtering options.
"""

import random
from collections import Counter

import nltk
from nltk.corpus import brown

# Download required NLTK data (run once)
try:
    nltk.data.find("corpora/brown")
except LookupError:
    nltk.download("brown", quiet=True)


def get_random_english_word() -> str:
    """
    Returns a completely random English word from Brown corpus.
    Filters out words with symbols and words with 3 letters or less.

    Original function by: uziellopez7
    """
    word_list = [w for w in brown.words() if (len(w) > 3) and (w.isalpha())]
    return random.choice(word_list).lower()


def get_random_common_word(top_n: int = 1000) -> str:
    """
    Returns a random word from the top N most commonly used words.

    Args:
        top_n: Number of top common words to sample from (default: 1000)

    Returns:
        Random word from the top N most common words

    Original function by: uziellopez7
    """
    frequency = Counter(w.lower() for w in brown.words() if w.isalpha())
    common_words = [w for w, c in frequency.most_common(top_n) if w.isalpha()]
    return random.choice(common_words)


def get_word_by_difficulty(difficulty: str) -> str:
    """
    Get a word based on difficulty level using word frequency.

    Args:
        difficulty: "easy" (top 100), "medium" (100-1000), "hard" (1000-5000)

    Returns:
        Random word matching difficulty

    Note: Built on top of get_random_common_word by uziellopez7
    """
    ranges = {"easy": 100, "medium": 1000, "hard": 5000}

    top_n = ranges.get(difficulty, 1000)
    return get_random_common_word(top_n)

