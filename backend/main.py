import sys
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

from application.audio_challenge_service import router as audio_router
from infrastructure.supabase_client import init_supabase_client

# Import routers (Removed the line for challenge_service)

# Initialize Supabase client
try:
    init_supabase_client()
    print("Supabase client initialized successfully")
except Exception as e:
    print(f"Failed to initialize Supabase client: {e}")
    print("Backend will continue without database connectivity")

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
    """Health check endpoint"""
    from infrastructure.audio_cache import get_cache_stats

    return {"status": "healthy", "cache_stats": get_cache_stats()}


@app.get("/debug/cache")
async def debug_cache():
    """Debug endpoint to check cache contents"""
    from infrastructure.audio_cache import (
        _audio_cache,
        _challenge_cache,
        get_cache_stats,
    )

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
