"""
Audio Challenge Service - TTS-based pronunciation challenges
Handles audio generation and challenge creation for pronunciation quizzes
"""

import base64
import io
from typing import List, Optional

from domain.audio_challenge_logic import (
    create_pronunciation_variants,
    generate_audio_challenge,
    generate_audio_for_word,
)
from domain.challenge_logic import calculate_xp_reward, get_feedback_message
from domain.models import Challenge, ChallengeResult
from fastapi import APIRouter, HTTPException, Response
from infrastructure.data_store import user_progress_store
from pydantic import BaseModel

router = APIRouter()


class CreateAudioChallengeRequest(BaseModel):
    difficulty: str = "medium"  # easy, medium, hard


class SubmitAudioAnswerRequest(BaseModel):
    user_answer: str  # A, B, C, or D
    user_id: int


@router.post("/challenge/audio/generate")
async def generate_audio_quiz(request: CreateAudioChallengeRequest):
    """
    Generate a new audio-based pronunciation challenge
    Returns challenge with audio data for each option
    """
    try:
        # Validate difficulty
        if request.difficulty not in ["easy", "medium", "hard"]:
            raise HTTPException(
                status_code=400, detail="Difficulty must be 'easy', 'medium', or 'hard'"
            )

        # Generate challenge with audio
        challenge_data = generate_audio_challenge(request.difficulty)

        return challenge_data

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error generating audio challenge: {str(e)}"
        )


@router.get("/challenge/audio/{challenge_id}/option/{option_letter}")
async def get_audio_option(challenge_id: int, option_letter: str):
    """
    Get audio file for a specific option
    Returns WAV audio file
    """
    try:
        # This would retrieve cached audio from storage
        # For now, we'll generate on demand
        from infrastructure.audio_cache import get_cached_audio

        audio_data = get_cached_audio(challenge_id, option_letter)

        if audio_data is None:
            raise HTTPException(status_code=404, detail="Audio not found")

        return Response(
            content=audio_data,
            media_type="audio/wav",
            headers={
                "Content-Disposition": f"inline; filename=option_{option_letter}.wav"
            },
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving audio: {str(e)}")


@router.post("/challenge/audio/{challenge_id}/submit")
async def submit_audio_answer(challenge_id: int, request: SubmitAudioAnswerRequest):
    """
    Submit answer for audio challenge
    """
    try:
        # Get challenge from cache
        from infrastructure.audio_cache import get_cached_challenge

        challenge = get_cached_challenge(challenge_id)

        if challenge is None:
            raise HTTPException(status_code=404, detail="Challenge not found")

        # Check answer
        is_correct = request.user_answer.upper() == challenge["correct_answer"].upper()

        # Calculate XP (base on difficulty)
        xp_map = {"easy": 10, "medium": 15, "hard": 20}
        base_xp = xp_map.get(challenge["difficulty"], 15)
        xp_earned = base_xp if is_correct else 0

        # Get feedback
        feedback = get_feedback_message(is_correct, 0)

        # Update user progress
        user_id = request.user_id
        if user_id in user_progress_store:
            progress = user_progress_store[user_id]
            if is_correct:
                progress.total_xp += xp_earned
                progress.challenges_completed += 1
        else:
            from domain.models import UserProgress

            user_progress_store[user_id] = UserProgress(
                user_id=user_id,
                total_xp=xp_earned if is_correct else 0,
                current_streak=1 if is_correct else 0,
                challenges_completed=1 if is_correct else 0,
            )

        return {
            "challenge_id": challenge_id,
            "user_id": user_id,
            "is_correct": is_correct,
            "xp_earned": xp_earned,
            "feedback": feedback,
            "correct_answer": challenge["correct_answer"],
            "correct_word": challenge["word"],
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error submitting answer: {str(e)}"
        )


@router.get("/difficulties")
async def get_difficulties():
    """
    Get available difficulty levels with descriptions
    """
    return {
        "difficulties": [
            {
                "id": "easy",
                "name": "Easy",
                "description": "Common words (top 100 most used)",
                "xp_reward": 10,
                "icon": "🟢",
            },
            {
                "id": "medium",
                "name": "Medium",
                "description": "Intermediate words (100-1000 frequency)",
                "xp_reward": 15,
                "icon": "🟡",
            },
            {
                "id": "hard",
                "name": "Hard",
                "description": "Advanced words (1000-5000 frequency)",
                "xp_reward": 20,
                "icon": "🔴",
            },
        ]
    }
