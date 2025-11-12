"""
Word Scrambler Utility
Original Author: uziellopez7
Extracted from: QuizPython/Multiple_Choice_Quiz.py
Function: Generate_Evil_Words

Generates incorrect answer options by scrambling word letters
while keeping first and last letters intact.
"""

import random
from typing import List


def generate_scrambled_options(word: str, num_options: int = 3) -> List[str]:
    """
    Generate wrong answer options by scrambling the middle letters.
    Keeps the first and last letter the same (makes it harder to spot).

    Original algorithm by: uziellopez7

    Args:
        word: The correct word to scramble
        num_options: Number of wrong options to generate (default: 3)

    Returns:
        List of scrambled words (wrong options)

    Example:
        >>> generate_scrambled_options("destiny", 3)
        ['dsetiny', 'detsiny', 'dsentiy']
    """
    if len(word) < 3:
        # For very short words, just return random permutations
        return [_random_permutation(word) for _ in range(num_options)]

    wrong_answers = []

    for _ in range(num_options):
        # Extract middle letters (everything except first and last)
        middle = list(word[1:-1])

        # Shuffle the middle letters
        random.shuffle(middle)

        # Reconstruct: first + shuffled_middle + last
        scrambled = word[0] + "".join(middle) + word[-1]

        # Make sure it's different from original
        if scrambled != word:
            wrong_answers.append(scrambled)
        else:
            # If somehow identical, try again with different permutation
            middle_permuted = list(word[1:-1])
            random.shuffle(middle_permuted)
            scrambled = word[0] + "".join(middle_permuted) + word[-1]
            wrong_answers.append(scrambled)

    return wrong_answers


def _random_permutation(word: str) -> str:
    """Helper: Generate random permutation of a word"""
    chars = list(word)
    random.shuffle(chars)
    return "".join(chars)


def generate_multiple_choice_options(correct_word: str) -> List[str]:
    """
    Generate 4 multiple choice options (1 correct + 3 wrong).
    Shuffles them randomly.

    Args:
        correct_word: The correct answer

    Returns:
        List of 4 options in random order
    """
    wrong_options = generate_scrambled_options(correct_word, num_options=3)
    all_options = [correct_word] + wrong_options
    random.shuffle(all_options)
    return all_options


# Keep original function name for backwards compatibility
def generate_evil_words(word: str) -> List[List[str]]:
    """
    Original function signature from Multiple_Choice_Quiz.py
    Kept for backwards compatibility.

    Returns options as list of single-element lists (for TTS compatibility).

    Original function by: uziellopez7
    """
    wrong_answers = [[word]]  # Correct answer first

    for _ in range(3):
        if len(word) > 2:
            middle = list(word[1:-1])
            random.shuffle(middle)
            scrambled = word[0] + "".join(middle) + word[-1]
        else:
            scrambled = "".join(random.sample(word, len(word)))

        wrong_answers.append([scrambled])

    return wrong_answers
