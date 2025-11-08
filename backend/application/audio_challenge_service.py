"""
Audio Challenge Service - TTS-based pronunciation challenges
Handles audio generation and challenge creation for pronunciation quizzes
"""

# Import from the correct location - domain.audio_challenge_logic has the generator
from datetime import datetime
from domain.audio_challenge_logic import generate_audio_challenge
from fastapi import APIRouter, HTTPException, Response
from infrastructure.audio_cache import get_cached_audio, get_cached_challenge
from infrastructure.data_store import get_user_progress, save_user_progress, create_quiz_attempt, initialize_user_progress
from infrastructure.supabase_client import get_client
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
        import traceback

        print(f"API ERROR: {str(e)}")
        traceback.print_exc()
        raise HTTPException(
            status_code=500, detail=f"Error generating audio challenge: {str(e)}"
        )


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
        import traceback

        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error retrieving audio: {str(e)}")


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

        # Calculate XP (base on difficulty)
        xp_map = {"easy": 10, "medium": 15, "hard": 20}
        base_xp = xp_map.get(challenge["difficulty"], 15)
        xp_earned = base_xp if is_correct else 0

        # Get feedback
        feedback = (
            "Correct! Great job!" if is_correct else "Incorrect. Try again!"
        )

        print(f"Result: {'CORRECT' if is_correct else 'INCORRECT'}")
        print(f"XP Earned: {xp_earned}")

        # Update user progress in database
        user_id = request.user_id
        progress = get_user_progress(user_id)

        if progress is None:
            # First time user - initialize progress
            progress = initialize_user_progress(user_id)

        # Update progress based on result
        if is_correct:
            progress.total_xp += xp_earned
            progress.challenges_completed += 1
            progress.current_streak += 1
        else:
            progress.current_streak = 0  # Reset streak on wrong answer

        progress.last_challenge_date = str(datetime.now().date())

        # Save updated progress
        save_user_progress(progress)

        # Save quiz attempt
        attempt_data = {
            'user_id': user_id,
            'challenge_id': challenge_id,
            'difficulty': challenge['difficulty'],
            'user_answer': request.user_answer,
            'correct_answer': challenge['correct_answer'],
            'is_correct': is_correct,
            'xp_earned': xp_earned
        }
        create_quiz_attempt(attempt_data)

        return {
            "challenge_id": challenge_id,
            "user_id": user_id,
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
        import traceback

        traceback.print_exc()
        raise HTTPException(
            status_code=500, detail=f"Error submitting answer: {str(e)}"
        )


@router.get("/user/{user_id}/progress")
async def get_user_progress_endpoint(user_id: int):
    """
    Get user progress and statistics
    """
    try:
        progress = get_user_progress(user_id)

        if progress is None:
            # Return default/empty progress for new users
            return {
                "user_id": user_id,
                "total_xp": 0,
                "current_streak": 0,
                "challenges_completed": 0,
                "accuracy_rate": 0.0,
                "words_practiced": 0,
                "sessions_count": 0,
                "avg_score": "0%",
                "improved_count": 0
            }

        # Get quiz statistics from attempts
        supabase = get_client()
        attempts_response = supabase.table('quiz_attempts').select('*').eq('user_id', user_id).execute()

        total_attempts = len(attempts_response.data) if attempts_response.data else 0
        correct_attempts = len([a for a in attempts_response.data if a['is_correct']]) if attempts_response.data else 0

        accuracy_rate = (correct_attempts / total_attempts * 100) if total_attempts > 0 else 0.0

        # Calculate sessions (group by date)
        sessions_dates = set()
        if attempts_response.data:
            for attempt in attempts_response.data:
                created_at = attempt['created_at']
                if created_at:
                    # Extract date from timestamp
                    date_str = created_at.split('T')[0] if 'T' in created_at else created_at.split(' ')[0]
                    sessions_dates.add(date_str)

        sessions_count = len(sessions_dates)

        # Calculate weekly stats (last 7 days)
        from datetime import datetime, timedelta, timezone
        week_ago = datetime.now(timezone.utc) - timedelta(days=7)  # Make it offset-aware
        weekly_attempts = []
        if attempts_response.data:
            for attempt in attempts_response.data:
                created_at = attempt['created_at']
                if created_at:
                    # Parse timestamp
                    if 'T' in created_at:
                        attempt_date = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
                    else:
                        # For naive datetimes, assume UTC
                        attempt_date = datetime.strptime(created_at, '%Y-%m-%d %H:%M:%S').replace(tzinfo=timezone.utc)
                    if attempt_date >= week_ago:
                        weekly_attempts.append(attempt)

        # Weekly accuracy
        weekly_correct = len([a for a in weekly_attempts if a['is_correct']])
        weekly_total = len(weekly_attempts)
        weekly_accuracy = (weekly_correct / weekly_total * 100) if weekly_total > 0 else 0.0

        # Calculate improvement (recent vs older performance)
        accuracy_improvement = 0.0
        words_improvement = 0.0

        if attempts_response.data and len(attempts_response.data) >= 10:
            # Compare last 10 attempts vs previous attempts
            recent_attempts = attempts_response.data[-10:]
            older_attempts = attempts_response.data[:-10] if len(attempts_response.data) > 10 else []

            if older_attempts:
                # Recent accuracy
                recent_correct = len([a for a in recent_attempts if a['is_correct']])
                recent_total = len(recent_attempts)
                recent_accuracy = (recent_correct / recent_total * 100) if recent_total > 0 else 0

                # Older accuracy
                older_correct = len([a for a in older_attempts if a['is_correct']])
                older_total = len(older_attempts)
                older_accuracy = (older_correct / older_total * 100) if older_total > 0 else 0

                # Improvement percentage
                accuracy_improvement = recent_accuracy - older_accuracy

                # Words improvement (recent activity vs older activity)
                recent_weeks = len(set([a['created_at'][:10] for a in recent_attempts]))  # Rough day count
                older_weeks = len(set([a['created_at'][:10] for a in older_attempts]))
                if older_weeks > 0:
                    words_improvement = ((len(recent_attempts) / max(recent_weeks, 1)) /
                                       (len(older_attempts) / max(older_weeks, 1)) - 1) * 100
                else:
                    words_improvement = 0.0

        # Improved count (correct answers in recent attempts)
        recent_correct_count = len([a for a in attempts_response.data[-10:] if a['is_correct']]) if attempts_response.data else 0

        return {
            "user_id": progress.user_id,
            "total_xp": progress.total_xp,
            "current_streak": progress.current_streak,
            "challenges_completed": progress.challenges_completed,
            "accuracy_rate": accuracy_rate,  # Overall accuracy
            "words_practiced": total_attempts,  # Total quizzes done
            "sessions_count": sessions_count,  # Unique practice days
            "avg_score": f"{weekly_accuracy:.1f}%",  # Weekly accuracy
            "improved_count": recent_correct_count,  # Recent correct answers
            "accuracy_improvement": accuracy_improvement,  # Improvement in accuracy
            "words_improvement": words_improvement  # Improvement in activity
        }

    except Exception as e:
        print(f"Error getting user progress: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error getting user progress: {str(e)}")


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
