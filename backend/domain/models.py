from dataclasses import dataclass
from enum import Enum
from typing import List, Optional


class ChallengeType(Enum):
    NAME = "name"
    WORD = "word"
    MULTIPLE_CHOICE = "multiple_choice"


@dataclass
class Challenge:
    id: int
    content: str
    ipa: Optional[str]
    hint: Optional[str]
    type: ChallengeType
    xp_reward: int
    # Multiple choice fields (optional)
    options: Optional[List[str]] = None
    correct_answer: Optional[str] = None  # For multiple choice
    # Audio challenge fields
    expected_pronunciation: Optional[str] = None  # For audio validation


@dataclass
class ChallengeResult:
    challenge_id: int
    user_id: int
    is_correct: bool
    xp_earned: int
    accuracy_score: Optional[float] = None  # For audio challenges (0-100)
    feedback: str = ""


@dataclass
class UserProgress:
    user_id: int
    total_xp: int
    current_streak: int
    challenges_completed: int
    last_challenge_date: Optional[str] = None
