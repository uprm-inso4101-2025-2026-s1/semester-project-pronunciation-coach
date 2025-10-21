from datetime import datetime
from typing import Dict, Optional

from domain.models import ChallengeResult, UserProgress

# In-memory storage (will be replaced with Supabase later)
_user_progress: Dict[int, UserProgress] = {}
_challenge_results: list[ChallengeResult] = []


def get_user_progress(user_id: int) -> UserProgress:
    """Get user progress from storage"""
    if user_id not in _user_progress:
        _user_progress[user_id] = UserProgress(
            user_id=user_id,
            total_xp=0,
            current_streak=0,
            challenges_completed=0,
            last_challenge_date=None,
        )
    return _user_progress[user_id]


def update_user_progress(
    user_id: int, xp_earned: int, is_correct: bool, new_streak: Optional[int] = None
) -> UserProgress:
    """Update user progress after challenge completion"""
    progress = get_user_progress(user_id)

    progress.total_xp += xp_earned
    progress.challenges_completed += 1
    progress.last_challenge_date = datetime.now().isoformat()

    if new_streak is not None:
        if new_streak == 0:
            # Same day, no change
            pass
        elif new_streak == 1:
            # Increment streak
            progress.current_streak += 1
        elif new_streak == -1:
            # Reset to 1
            progress.current_streak = 1

    return progress


def save_challenge_result(result: ChallengeResult) -> None:
    """Save challenge result to storage"""
    _challenge_results.append(result)


def get_user_challenge_history(user_id: int) -> list[ChallengeResult]:
    """Get user's challenge history"""
    return [r for r in _challenge_results if r.user_id == user_id]
