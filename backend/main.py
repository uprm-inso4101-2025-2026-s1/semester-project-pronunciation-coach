"""
Pronunciation Coach Backend API.

FastAPI application serving audio challenges and progress tracking
for the Pronunciation Coach mobile app.
"""

import sys
from pathlib import Path

# Third-party imports
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# First-party imports
from api.audio_challenge_service import router as audio_router
from infrastructure.audio_cache import (
    _audio_cache,
    _challenge_cache,
    get_cache_stats,
)

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

# Note: Supabase client removed - all data operations now handled by frontend

app = FastAPI(
    title="Pronunciation Coach API",
    description="Backend for pronunciation coach app - Audio Challenges & Quizzes",
    version="0.2.0",
)

# Enable CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
# Removed the inclusion of challenge_router.
app.include_router(audio_router, prefix="/api", tags=["audio"])


@app.get("/")
async def root():
    """Root endpoint returning API information."""
    return {
        "message": "Pronunciation Coach API - Audio Challenges",
        "status": "running",
        "version": "0.2.0",
        "docs": "/docs",
        "features": [
            "Audio pronunciation challenges",
            "Dynamic word generation",
            "User progress tracking",
            # Removed "Text-based challenges" as its service was deleted
        ],
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "cache_stats": get_cache_stats()}


@app.get("/debug/cache")
async def debug_cache():
    """Debug endpoint to check cache contents."""
    stats = get_cache_stats()

    # Get all cached challenge IDs and audio keys
    challenge_ids = list(_challenge_cache.keys())
    audio_keys = list(_audio_cache.keys())

    return {
        "status": "ok",
        "stats": stats,
        "cached_challenges": challenge_ids,
        "cached_audio_keys": audio_keys,
        "sample_audio_keys": audio_keys[:10] if audio_keys else [],
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
