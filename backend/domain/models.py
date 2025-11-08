"""
Domain models for the Pronunciation Coach application.

Defines data structures for challenges, results, and user progress.
"""

from dataclasses import dataclass
from enum import Enum
from typing import List, Optional


class ChallengeType(Enum):
    """Enumeration of different challenge types."""
    NAME = "name"
    WORD = "word"
    MULTIPLE_CHOICE = "multiple_choice"


@dataclass
class Challenge:  # pylint: disable=too-many-instance-attributes
    """Represents a pronunciation challenge."""
    id: int
    content: str
    type: ChallengeType
    xp_reward: int
    ipa: Optional[str] = None  # ← Make optional with default None
    hint: Optional[str] = None
    # Multiple choice fields (optional)
    options: Optional[List[str]] = None
    correct_answer: Optional[str] = None
    # Audio challenge fields
    expected_pronunciation: Optional[str] = None


@dataclass
class ChallengeResult:
    """Represents the result of a challenge attempt."""
    challenge_id: int
    user_id: int
    is_correct: bool
    xp_earned: int
    accuracy_score: Optional[float] = None
    feedback: str = ""


@dataclass
class UserProgress:
    """Represents a user's overall progress in the application."""
    user_id: int
    total_xp: int
    current_streak: int
    challenges_completed: int
    last_challenge_date: Optional[str] = None
