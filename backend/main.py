import sys
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

# Now import
from application.challenge_service import router as challenge_router

app = FastAPI(
    title="Pronunciation Coach API",
    description="Backend for pronunciation coach app - Daily Challenges",
    version="0.1.0",
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
app.include_router(challenge_router, prefix="/api", tags=["challenges"])


@app.get("/")
async def root():
    return {
        "message": "Pronunciation Coach API - Daily Challenges",
        "status": "running",
        "docs": "/docs",
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
