"""
Data Store - In-memory storage for user progress
In production, this would be replaced with Supabase/database
"""

from typing import Dict

from domain.models import UserProgress

# In-memory storage for user progress
# Key: user_id, Value: UserProgress object
user_progress_store: Dict[int, UserProgress] = {}

# Initialize with a sample user for testing
user_progress_store[1] = UserProgress(
    user_id=1,
    total_xp=0,
    current_streak=0,
    challenges_completed=0,
    last_challenge_date=None,
)
