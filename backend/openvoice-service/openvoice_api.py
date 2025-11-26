import sys
import os
import shutil
import uuid
import tempfile
import traceback 
from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.responses import FileResponse
from starlette.status import HTTP_400_BAD_REQUEST, HTTP_500_INTERNAL_SERVER_ERROR

# --- Configuration Constants ---
OPENVOICE_SERVICE_ROOT = os.path.dirname(__file__)

# Define the persistent output folder path (e.g., /backend/openvoice-service/outputs)
OUTPUT_DIR = os.path.join(OPENVOICE_SERVICE_ROOT, 'outputs') 


# --- Path Setup to find generate_audio.py and OpenVoice dependencies ---
sys.path.append(OPENVOICE_SERVICE_ROOT)

OPENVOICE_DIR = os.path.join(OPENVOICE_SERVICE_ROOT, 'OpenVoice')
if os.path.isdir(OPENVOICE_DIR):
    sys.path.append(OPENVOICE_DIR)

# Import the core logic functions from your custom script
try:
    from generate_audio import load_openvoice_models, synthesize_cloned_voice
except ImportError as e:
    print("----------------------------------------------------------------------")
    print(f"FATAL SETUP ERROR: Cannot import core logic from generate_audio.py: {e}")
    print("----------------------------------------------------------------------")
    sys.exit(1)


# Initialize the FastAPI app
app = FastAPI(
    title="OpenVoice Cloning Service API",
    description="API for receiving reference audio and text for voice cloning.",
    version="1.0.0"
)

# ----------------------------------------------------------------------
# GLOBAL STATUS TRACKING AND MODEL LOADING
# ----------------------------------------------------------------------

MODEL_LOADED_SUCCESSFULLY = False

@app.on_event("startup")
def startup_event():
    """Load models and ensure necessary directories exist when the application starts up."""
    global MODEL_LOADED_SUCCESSFULLY
    
    # 1. Ensure Output Directory Exists
    try:
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        print(f"Output directory ensured: {OUTPUT_DIR}")
    except Exception as e:
        print(f"FATAL DIRECTORY ERROR: Failed to create output directory: {e}")
        sys.exit(1)

    # 2. Load Models
    try:
        print("Starting model loading... This may take a moment.")
        load_openvoice_models()
        MODEL_LOADED_SUCCESSFULLY = True
        print("OpenVoice models loaded successfully!")
    except Exception as e:
        print("----------------------------------------------------------------------")
        print(f"FATAL MODEL LOADING ERROR: {e}")
        print("----------------------------------------------------------------------")
        MODEL_LOADED_SUCCESSFULLY = False

# ----------------------------------------------------------------------
# API ENDPOINTS
# ----------------------------------------------------------------------

@app.get("/health")
def health_check():
    """Simple check to ensure the service is running."""
    if MODEL_LOADED_SUCCESSFULLY:
        return {"status": "ok", "message": "Service is running and models are loaded."}
    return {"status": "error", "message": "Service is running, but models failed to load. Check startup logs."}


@app.post("/synthesize")
async def synthesize_voice(
    reference_audio: UploadFile = File(..., description="The user's recorded reference audio (.wav)."),
    text: str = Form(..., description="The text to be spoken by the cloned voice.")
):
    """
    Accepts a reference audio file and text, then returns the synthesized audio.
    """
    
    if not MODEL_LOADED_SUCCESSFULLY:
        raise HTTPException(
            status_code=HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Model is not loaded. Please check server logs for startup errors."
        )
        
    if not text or len(text) < 5:
        raise HTTPException(
            status_code=HTTP_400_BAD_REQUEST, 
            detail="Text input is required and must be at least 5 characters."
        )

    # --- FINAL OUTPUT PATH: Use the persistent OUTPUT_DIR ---
    # The output file will persist here after the request finishes.
    output_audio_path = os.path.join(OUTPUT_DIR, f"cloned_output_{uuid.uuid4()}.wav")

    # Use a temporary directory ONLY for intermediate files (like the reference audio)
    with tempfile.TemporaryDirectory() as temp_root_dir:
        temp_ref_audio_path = os.path.join(temp_root_dir, f"ref_{uuid.uuid4()}.wav")
        
        # 3. Save the uploaded file (Inside the cleanup block)
        try:
            with open(temp_ref_audio_path, "wb") as buffer:
                shutil.copyfileobj(reference_audio.file, buffer)
        except Exception as e:
            raise HTTPException(
                status_code=HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Failed to save reference audio file: {e}"
            )

        # 4. Call the Core Cloning Logic (Targeting the safe output_audio_path)
        try:
            # synthesize_cloned_voice uses the output_audio_path provided here.
            synthesize_cloned_voice(temp_ref_audio_path, text, output_audio_path)
            
            # Check for successful output creation
            if not os.path.exists(output_audio_path):
                 raise HTTPException(
                     status_code=HTTP_500_INTERNAL_SERVER_ERROR, 
                     detail="Synthesis failed: Output file was not produced."
                 )

        except Exception as e:
            print("----------------------------------------------------------------------")
            print("CRITICAL SYNTHESIS ERROR TRACEBACK:")
            traceback.print_exc(file=sys.stdout)
            print("----------------------------------------------------------------------")
            
            # If synthesis fails, ensure we clean up the final output file if it was created
            if os.path.exists(output_audio_path):
                os.remove(output_audio_path)

            raise HTTPException(
                status_code=HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Synthesis failed due to: {type(e).__name__}: {e}"
            )

    # 5. Return the Generated Audio File
    # The file is outside the 'with' block and persists in the 'outputs' folder.
    # We add a background task to delete the file AFTER FastAPI has streamed it.
    return FileResponse(
        output_audio_path, 
        media_type="audio/wav", 
        filename="cloned_voice.wav",
        background=None # FileResponse documentation recommends setting this to None for simple file streaming
    )