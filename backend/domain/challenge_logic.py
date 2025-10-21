from datetime import datetime
from typing import List

from domain.models import Challenge, ChallengeResult, ChallengeType

# Sample challenges
CHALLENGES: List[Challenge] = [
    Challenge(
        id=1,
        content="Christopher",
        ipa="/ˈkrɪstəfər/",
        hint="Common English name",
        type=ChallengeType.NAME,
        xp_reward=20,
        expected_pronunciation="KRIS-tuh-fer",
    ),
    Challenge(
        id=2,
        content="Elizabeth",
        ipa="/ɪˈlɪzəbəθ/",
        hint="Traditional English name",
        type=ChallengeType.NAME,
        xp_reward=20,
        expected_pronunciation="ih-LIZ-uh-beth",
    ),
    Challenge(
        id=3,
        content="Pronunciation",
        ipa="/prəˌnʌnsiˈeɪʃən/",
        hint="The way words are spoken",
        type=ChallengeType.WORD,
        xp_reward=10,
        expected_pronunciation="pruh-nun-see-AY-shun",
    ),
    Challenge(
        id=4,
        content="Beautiful",
        ipa="/ˈbjuːtɪfəl/",
        hint="Pleasing to the eye",
        type=ChallengeType.WORD,
        xp_reward=10,
        expected_pronunciation="BYOO-tih-ful",
    ),
    # Multiple choice challenges
    Challenge(
        id=5,
        content="How do you pronounce 'thorough'?",
        ipa=None,
        type=ChallengeType.MULTIPLE_CHOICE,
        xp_reward=15,
        options=["THUR-oh", "THOR-uff", "thur-ROW", "THUH-roh"],
        correct_answer="A",
        hint="Think of 'through' but different",
    ),
    Challenge(
        id=6,
        content="Which word has a silent 'k'?",
        ipa=None,
        type=ChallengeType.MULTIPLE_CHOICE,
        xp_reward=10,
        options=["Kite", "Knife", "Kick", "Kind"],
        correct_answer="B",
        hint="You use this to cut things",
    ),
]


def get_daily_challenge() -> Challenge:
    """Get a random challenge (simplified - in production use date-based selection)"""
    import random

    return random.choice(CHALLENGES)


def get_challenge_by_id(challenge_id: int) -> Challenge:
    """Get specific challenge by ID"""
    for challenge in CHALLENGES:
        if challenge.id == challenge_id:
            return challenge
    raise ValueError(f"Challenge {challenge_id} not found")


def check_multiple_choice_answer(challenge_id: int, user_answer: str) -> bool:
    """Check if multiple choice answer is correct"""
    challenge = get_challenge_by_id(challenge_id)

    if challenge.type != ChallengeType.MULTIPLE_CHOICE:
        raise ValueError("This challenge is not multiple choice")

    return user_answer.upper() == challenge.correct_answer.upper()


def simulate_audio_pronunciation_check(
    challenge_id: int, audio_data: bytes
) -> tuple[bool, float]:
    """
    Simulate audio pronunciation checking
    Returns: (is_correct, accuracy_score)

    In production, this would call the ML model
    For now, we'll simulate with random accuracy
    """
    import random

    challenge = get_challenge_by_id(challenge_id)

    if challenge.type == ChallengeType.MULTIPLE_CHOICE:
        raise ValueError("This challenge requires multiple choice answer")

    # Simulate ML model result
    accuracy_score = random.uniform(60, 100)  # Random score between 60-100
    is_correct = accuracy_score >= 75  # 75% threshold

    return is_correct, accuracy_score


def calculate_xp_reward(
    challenge: Challenge, is_correct: bool, accuracy_score: float = 0
) -> int:
    """Calculate XP earned based on correctness and accuracy"""
    if not is_correct:
        return 0

    base_xp = challenge.xp_reward

    # Bonus XP for high accuracy on audio challenges
    if challenge.type in [ChallengeType.NAME, ChallengeType.WORD]:
        if accuracy_score >= 95:
            return int(base_xp * 1.5)  # 50% bonus
        elif accuracy_score >= 85:
            return int(base_xp * 1.2)  # 20% bonus

    return base_xp


def get_feedback_message(
    is_correct: bool,
    accuracy_score: float = 0,
    challenge_type: ChallengeType = ChallengeType.WORD,
) -> str:
    """Generate feedback message based on result"""
    if not is_correct:
        return "Try again! Practice makes perfect! 💪"

    if challenge_type in [ChallengeType.NAME, ChallengeType.WORD]:
        if accuracy_score >= 95:
            return "Perfect pronunciation! 🎉"
        elif accuracy_score >= 85:
            return "Excellent work! 🌟"
        elif accuracy_score >= 75:
            return "Good job! Keep practicing! 👍"

    return "Correct! Well done! ✨"


def update_streak(last_challenge_date: str, is_correct: bool) -> int:
    """
    Update user streak based on last challenge date
    Returns new streak count
    """
    if not is_correct:
        return 0  # Reset streak on wrong answer

    today = datetime.now().date()

    if not last_challenge_date:
        return 1  # First challenge

    last_date = datetime.fromisoformat(last_challenge_date).date()
    days_diff = (today - last_date).days

    if days_diff == 0:
        # Same day - don't increment
        return 0  # Return 0 to indicate no change
    elif days_diff == 1:
        # Next day - increment streak
        return 1  # Return 1 to indicate increment
    else:
        # Missed days - reset streak
        return -1  # Return -1 to indicate reset to 1
