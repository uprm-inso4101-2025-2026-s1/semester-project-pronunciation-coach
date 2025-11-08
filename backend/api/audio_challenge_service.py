"""
Audio Challenge Service - TTS-based pronunciation challenges
Handles audio generation and challenge creation for pronunciation quizzes
"""

import traceback

from fastapi import APIRouter, HTTPException, Response
from pydantic import BaseModel

from domain.audio_challenge_logic import generate_audio_challenge
from infrastructure.audio_cache import get_cached_audio, get_cached_challenge

router = APIRouter()


class CreateAudioChallengeRequest(BaseModel):
    """Request model for creating audio challenges."""
    difficulty: str = "medium"  # easy, medium, hard


class SubmitAudioAnswerRequest(BaseModel):
    """Request model for submitting audio challenge answers."""
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

        print(f"Generating audio challenge for difficulty: {request.difficulty}")

        # Generate challenge with audio (from domain.audio_challenge_logic)
        challenge_data = generate_audio_challenge(request.difficulty)

        print("Challenge generated successfully")
        print(f"Challenge ID: {challenge_data['id']}")
        print(f"Word: {challenge_data['word']}")
        print(f"Correct Answer: {challenge_data['correct_answer']}")
        print(f"Options: {[opt['letter'] for opt in challenge_data['options']]}")

        return challenge_data

    except Exception as e:
        print(f"API ERROR: {str(e)}")
        traceback.print_exc()
        raise HTTPException(
            status_code=500, detail=f"Error generating audio challenge: {str(e)}"
        ) from e


@router.get("/challenge/audio/{challenge_id}/option/{option_letter}")
async def get_audio_option(challenge_id: int, option_letter: str):
    """
    Get audio file for a specific option
    Returns MP3 audio file
    """
    try:
        print(f"Retrieving audio: Challenge {challenge_id}, Option {option_letter}")

        # Retrieve cached audio from infrastructure.audio_cache
        audio_data = get_cached_audio(challenge_id, option_letter)

        if audio_data is None:
            print("Audio not found in cache")
            raise HTTPException(
                status_code=404,
                detail=f"Audio not found for challenge {challenge_id}, option {option_letter}",
            )

        print(f"Serving audio: {len(audio_data)} bytes")

        return Response(
            content=audio_data,
            media_type="audio/mpeg",
            headers={
                "Content-Disposition": f"inline; filename=option_{option_letter}.mp3",
                "Accept-Ranges": "bytes",
                "Cache-Control": "public, max-age=3600",
            },
        )

    except HTTPException:
        raise
    except Exception as e:
        print(f"Error retrieving audio: {str(e)}")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error retrieving audio: {str(e)}") from e


@router.post("/challenge/audio/{challenge_id}/submit")
async def submit_audio_answer(challenge_id: int, request: SubmitAudioAnswerRequest):
    """
    Submit answer for audio challenge
    """
    try:
        print(f"Submitting answer for challenge {challenge_id}")
        print(f"User answer: {request.user_answer}")

        # Get challenge from infrastructure.audio_cache
        challenge = get_cached_challenge(challenge_id)

        if challenge is None:
            print("Challenge not found in cache")
            raise HTTPException(
                status_code=404, detail=f"Challenge {challenge_id} not found"
            )

        print(f"Correct answer: {challenge['correct_answer']}")

        # Check answer
        is_correct = request.user_answer.upper() == challenge["correct_answer"].upper()

        # Calculate XP (base on difficulty) - moved to frontend
        xp_map = {"easy": 10, "medium": 15, "hard": 20}
        base_xp = xp_map.get(challenge["difficulty"], 15)
        xp_earned = base_xp if is_correct else 0

        # Get feedback
        feedback = (
            "Correct! Great job!" if is_correct else "Incorrect. Try again!"
        )

        print(f"Result: {'CORRECT' if is_correct else 'INCORRECT'}")
        print(f"XP Earned: {xp_earned}")

        # Note: Progress data is now saved directly by the frontend
        # Backend only handles quiz validation and audio logic

        return {
            "challenge_id": challenge_id,
            "user_id": request.user_id,
            "is_correct": is_correct,
            "xp_earned": xp_earned,
            "feedback": feedback,
            "correct_answer": challenge["correct_answer"],
            "correct_word": challenge["word"],
            "explanation": f"The correct pronunciation is option {challenge['correct_answer']}",
        }

    except HTTPException:
        raise
    except Exception as e:
        print(f"Error submitting answer: {str(e)}")
        traceback.print_exc()
        raise HTTPException(
            status_code=500, detail=f"Error submitting answer: {str(e)}"
        ) from e




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
                "icon": "green",
            },
            {
                "id": "medium",
                "name": "Medium",
                "description": "Intermediate words (100-1000 frequency)",
                "xp_reward": 15,
                "icon": "yellow",
            },
            {
                "id": "hard",
                "name": "Hard",
                "description": "Advanced words (1000-5000 frequency)",
                "xp_reward": 20,
                "icon": "red",
            },
        ]
    }
