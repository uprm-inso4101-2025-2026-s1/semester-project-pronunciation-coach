"""
Challenge Service - API Endpoints
Handles HTTP requests for challenges
"""

from typing import Optional

from domain.challenge_logic import (
    CHALLENGES,
    calculate_xp_reward,
    check_multiple_choice_answer,
    generate_word_challenge,
    get_challenge_by_id,
    get_daily_challenge,
    get_feedback_message,
)
from domain.models import Challenge, ChallengeResult, UserProgress
from fastapi import APIRouter, HTTPException
from infrastructure.data_store import user_progress_store
from pydantic import BaseModel

router = APIRouter()


# Request/Response Models
class SubmitAnswerRequest(BaseModel):
    user_answer: str
    user_id: int


class GenerateChallengeRequest(BaseModel):
    difficulty: str = "medium"


# Helper function to convert Challenge to dict
def challenge_to_dict(challenge: Challenge) -> dict:
    return {
        "id": challenge.id,
        "content": challenge.content,
        "type": challenge.type.value,
        "xp_reward": challenge.xp_reward,
        "ipa": challenge.ipa,
        "hint": challenge.hint,
        "options": challenge.options,
        "correct_answer": challenge.correct_answer,
        "expected_pronunciation": challenge.expected_pronunciation,
    }


@router.get("/challenges")
async def get_all_challenges():
    """Get all available challenges"""
    return [challenge_to_dict(c) for c in CHALLENGES]


@router.get("/challenge/daily")
async def get_daily():
    """Get today's daily challenge"""
    challenge = get_daily_challenge()
    return challenge_to_dict(challenge)


@router.get("/challenge/{challenge_id}")
async def get_challenge(challenge_id: int):
    """Get a specific challenge by ID"""
    try:
        challenge = get_challenge_by_id(challenge_id)
        return challenge_to_dict(challenge)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))


@router.post("/challenge/generate")
async def generate_challenge(request: GenerateChallengeRequest):
    """Generate a dynamic word challenge"""
    try:
        challenge = generate_word_challenge(request.difficulty)
        return challenge_to_dict(challenge)
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error generating challenge: {str(e)}"
        )


@router.post("/challenge/{challenge_id}/submit")
async def submit_answer(challenge_id: int, request: SubmitAnswerRequest):
    """Submit an answer for a challenge"""
    try:
        challenge = get_challenge_by_id(challenge_id)

        # Check if answer is correct
        is_correct = check_multiple_choice_answer(challenge_id, request.user_answer)

        # Calculate XP
        xp_earned = calculate_xp_reward(challenge, is_correct)

        # Get feedback
        feedback = get_feedback_message(is_correct, 0, challenge.type)

        # Update user progress
        user_id = request.user_id
        if user_id in user_progress_store:
            progress = user_progress_store[user_id]
            if is_correct:
                progress.total_xp += xp_earned
                progress.challenges_completed += 1
        else:
            # Create new progress entry
            user_progress_store[user_id] = UserProgress(
                user_id=user_id,
                total_xp=xp_earned if is_correct else 0,
                current_streak=1 if is_correct else 0,
                challenges_completed=1 if is_correct else 0,
            )

        # Create result
        result = ChallengeResult(
            challenge_id=challenge_id,
            user_id=user_id,
            is_correct=is_correct,
            xp_earned=xp_earned,
            feedback=feedback,
        )

        return {
            "challenge_id": result.challenge_id,
            "user_id": result.user_id,
            "is_correct": result.is_correct,
            "xp_earned": result.xp_earned,
            "accuracy_score": result.accuracy_score,
            "feedback": result.feedback,
        }

    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error submitting answer: {str(e)}"
        )


@router.get("/progress/{user_id}")
async def get_user_progress(user_id: int):
    """Get user's progress and stats"""
    if user_id not in user_progress_store:
        # Return default progress for new users
        return {
            "user_id": user_id,
            "total_xp": 0,
            "current_streak": 0,
            "challenges_completed": 0,
            "last_challenge_date": None,
        }

    progress = user_progress_store[user_id]
    return {
        "user_id": progress.user_id,
        "total_xp": progress.total_xp,
        "current_streak": progress.current_streak,
        "challenges_completed": progress.challenges_completed,
        "last_challenge_date": progress.last_challenge_date,
    }


@router.post("/progress/{user_id}/reset")
async def reset_user_progress(user_id: int):
    """Reset user's progress (for testing)"""
    if user_id in user_progress_store:
        del user_progress_store[user_id]

    return {"message": f"Progress reset for user {user_id}"}
