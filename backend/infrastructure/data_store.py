"""
Data Store - Supabase database storage for user progress and quiz attempts
"""

from typing import Optional, Dict, Any
from datetime import datetime
import uuid

from domain.models import UserProgress, ChallengeResult
from .supabase_client import get_client

def get_user_progress(user_id: int) -> Optional[UserProgress]:
    """Get user progress from database"""
    try:
        supabase = get_client()
        response = supabase.table('user_progress').select('*').eq('user_id', user_id).execute()

        if response.data and len(response.data) > 0:
            data = response.data[0]
            return UserProgress(
                user_id=data['user_id'],
                total_xp=data['total_xp'],
                current_streak=data['current_streak'],
                challenges_completed=data['challenges_completed'],
                last_challenge_date=data.get('last_challenge_date')
            )
        return None
    except Exception as e:
        print(f"Error getting user progress: {e}")
        return None

def save_user_progress(progress: UserProgress) -> bool:
    """Save or update user progress in database"""
    try:
        supabase = get_client()
        data = {
            'user_id': progress.user_id,
            'total_xp': progress.total_xp,
            'current_streak': progress.current_streak,
            'challenges_completed': progress.challenges_completed,
            'last_challenge_date': progress.last_challenge_date
        }

        # Upsert - insert or update if exists
        response = supabase.table('user_progress').upsert(data).execute()
        return True
    except Exception as e:
        print(f"Error saving user progress: {e}")
        return False

def create_quiz_attempt(attempt_data: Dict[str, Any]) -> bool:
    """Save quiz attempt to database"""
    try:
        supabase = get_client()
        data = {
            'user_id': attempt_data['user_id'],
            'challenge_id': attempt_data['challenge_id'],
            'difficulty': attempt_data['difficulty'],
            'user_answer': attempt_data['user_answer'],
            'correct_answer': attempt_data['correct_answer'],
            'is_correct': attempt_data['is_correct'],
            'xp_earned': attempt_data['xp_earned']
        }

        response = supabase.table('quiz_attempts').insert(data).execute()
        return True
    except Exception as e:
        print(f"Error saving quiz attempt: {e}")
        return False

def initialize_user_progress(user_id: int) -> UserProgress:
    """Create initial progress record for new user"""
    progress = UserProgress(
        user_id=user_id,
        total_xp=0,
        current_streak=0,
        challenges_completed=0,
        last_challenge_date=None
    )

    if save_user_progress(progress):
        return progress

    # Fallback if save fails
    raise Exception(f"Failed to initialize progress for user {user_id}")

# Legacy compatibility - maintain a simple in-memory cache for frequently accessed data
_user_progress_cache: Dict[int, UserProgress] = {}
