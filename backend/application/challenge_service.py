from typing import List, Optional

from fastapi import APIRouter, File, HTTPException, UploadFile
from pydantic import BaseModel

# Create router FIRST (before other imports)
router = APIRouter()


# Test endpoint to verify router works
@router.get("/test")
async def test():
    return {"message": "Router works!"}


# Now try importing domain/infrastructure
try:
    from domain.challenge_logic import (
        CHALLENGES,
        calculate_xp_reward,
        check_multiple_choice_answer,
        get_challenge_by_id,
        get_daily_challenge,
        get_feedback_message,
        simulate_audio_pronunciation_check,
        update_streak,
    )
    from domain.models import ChallengeResult, ChallengeType
    from infrastructure.data_store import (
        get_user_progress,
        save_challenge_result,
        update_user_progress,
    )

    print("✓ All domain/infrastructure imports successful")
except ImportError as e:
    print(f"✗ Import error: {e}")
    # Continue anyway so router still exists


# Request/Response Models
class ChallengeResponse(BaseModel):
    id: int
    content: str
    ipa: Optional[str] = None
    hint: Optional[str] = None
    type: str
    xp_reward: int
    options: Optional[List[str]] = None


class MultipleChoiceSubmission(BaseModel):
    user_id: int
    challenge_id: int
    selected_answer: str


class AudioSubmission(BaseModel):
    user_id: int
    challenge_id: int


class ChallengeResultResponse(BaseModel):
    correct: bool
    xp_earned: int
    feedback: str
    accuracy_score: Optional[float] = None
    new_total_xp: int
    new_streak: int


class ProgressResponse(BaseModel):
    user_id: int
    total_xp: int
    current_streak: int
    challenges_completed: int


# Endpoints
@router.get("/challenge/daily", response_model=ChallengeResponse)
async def get_daily():
    """Get today's daily challenge"""
    try:
        challenge = get_daily_challenge()

        return ChallengeResponse(
            id=challenge.id,
            content=challenge.content,
            ipa=challenge.ipa,
            hint=challenge.hint,
            type=challenge.type.value,
            xp_reward=challenge.xp_reward,
            options=challenge.options,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/challenge/{challenge_id}", response_model=ChallengeResponse)
async def get_challenge(challenge_id: int):
    """Get specific challenge by ID"""
    try:
        challenge = get_challenge_by_id(challenge_id)

        return ChallengeResponse(
            id=challenge.id,
            content=challenge.content,
            ipa=challenge.ipa,
            hint=challenge.hint,
            type=challenge.type.value,
            xp_reward=challenge.xp_reward,
            options=challenge.options,
        )
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))


@router.get("/challenges", response_model=List[ChallengeResponse])
async def get_all_challenges():
    """Get all available challenges"""
    try:
        return [
            ChallengeResponse(
                id=c.id,
                content=c.content,
                ipa=c.ipa,
                hint=c.hint,
                type=c.type.value,
                xp_reward=c.xp_reward,
                options=c.options,
            )
            for c in CHALLENGES
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post(
    "/challenge/submit/multiple-choice", response_model=ChallengeResultResponse
)
async def submit_multiple_choice(submission: MultipleChoiceSubmission):
    """Submit multiple choice challenge answer"""
    try:
        # Get challenge
        challenge = get_challenge_by_id(submission.challenge_id)

        # Check answer
        is_correct = check_multiple_choice_answer(
            submission.challenge_id, submission.selected_answer
        )

        # Calculate XP
        xp_earned = calculate_xp_reward(challenge, is_correct)

        # Get feedback
        feedback = get_feedback_message(is_correct, 0, ChallengeType.MULTIPLE_CHOICE)

        # Update progress
        progress = get_user_progress(submission.user_id)
        streak_change = update_streak(progress.last_challenge_date, is_correct)
        progress = update_user_progress(
            submission.user_id, xp_earned, is_correct, streak_change
        )

        # Save result
        result = ChallengeResult(
            challenge_id=submission.challenge_id,
            user_id=submission.user_id,
            is_correct=is_correct,
            xp_earned=xp_earned,
            feedback=feedback,
        )
        save_challenge_result(result)

        return ChallengeResultResponse(
            correct=is_correct,
            xp_earned=xp_earned,
            feedback=feedback,
            new_total_xp=progress.total_xp,
            new_streak=progress.current_streak,
        )

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/challenge/submit/audio", response_model=ChallengeResultResponse)
async def submit_audio_challenge(
    user_id: int, challenge_id: int, audio: UploadFile = File(...)
):
    """Submit audio recording for pronunciation challenge"""
    try:
        # Get challenge
        challenge = get_challenge_by_id(challenge_id)

        # Read audio file
        audio_data = await audio.read()

        # Check pronunciation (simulated for now)
        is_correct, accuracy_score = simulate_audio_pronunciation_check(
            challenge_id, audio_data
        )

        # Calculate XP
        xp_earned = calculate_xp_reward(challenge, is_correct, accuracy_score)

        # Get feedback
        feedback = get_feedback_message(is_correct, accuracy_score, challenge.type)

        # Update progress
        progress = get_user_progress(user_id)
        streak_change = update_streak(progress.last_challenge_date, is_correct)
        progress = update_user_progress(user_id, xp_earned, is_correct, streak_change)

        # Save result
        result = ChallengeResult(
            challenge_id=challenge_id,
            user_id=user_id,
            is_correct=is_correct,
            xp_earned=xp_earned,
            accuracy_score=accuracy_score,
            feedback=feedback,
        )
        save_challenge_result(result)

        return ChallengeResultResponse(
            correct=is_correct,
            xp_earned=xp_earned,
            feedback=feedback,
            accuracy_score=accuracy_score,
            new_total_xp=progress.total_xp,
            new_streak=progress.current_streak,
        )

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/progress/{user_id}", response_model=ProgressResponse)
async def get_progress(user_id: int):
    """Get user progress"""
    try:
        progress = get_user_progress(user_id)

        return ProgressResponse(
            user_id=progress.user_id,
            total_xp=progress.total_xp,
            current_streak=progress.current_streak,
            challenges_completed=progress.challenges_completed,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
