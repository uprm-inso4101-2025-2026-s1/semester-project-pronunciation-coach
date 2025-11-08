# Semester Project – Pronunciation Coach

A Flutter application for the course semester project.  
This repo has been initialized as a proper Flutter project so everyone can clone and run it immediately.

## 📋 Prerequisites

- Flutter SDK installed
- Python 3.8+ installed
- Git installed
- A Supabase account (free at [supabase.com](https://supabase.com))

## 🚀 Getting Started

### 1. Verify Your Setup

**Flutter:**

```bash
flutter --version
flutter doctor
```

**Python (for backend):**

```bash
python3 --version  # Should be 3.8 or higher
pip3 --version
```

### 2. Clone the Repository

```bash
git clone https://github.com/<org-or-username>/semester-project-pronunciation-coach.git
cd semester-project-pronunciation-coach
```

---

## 📱 Flutter App Setup

### 1. Install Dependencies

```bash
cd app
flutter pub get
```

### 2. Environment Setup

#### Create your environment file

Copy the example file:

```bash
cp lib/core/config/env.example.dart lib/core/config/env.dart
```

#### Get your Supabase credentials

1. Go to [supabase.com/dashboard](https://supabase.com/dashboard)
2. Select your project → **Settings** → **API**
3. Copy these two values:
   - **Project URL**
   - **anon public key**

#### Add your credentials

Open `lib/core/config/env.dart` and replace these two lines:

```dart
defaultValue: 'https://your-project-id.supabase.co',  // ← Paste your Project URL here
```

```dart
defaultValue: 'your-anon-key-here',  // ← Paste your anon public key here
```

Save the file.

### 3. Run the App

```bash
flutter run
```

Done! 🎉

> **Important:** The `env.dart` file is gitignored and stays on your machine only. Never commit it.

---

## 🐍 Backend API Setup

The backend is a FastAPI service that handles quiz logic, word generation, and pronunciation challenges.

### 1. Navigate to Backend Folder

```bash
cd backend
```

### 2. Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

You should see `(venv)` in your terminal prompt.

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Download NLTK Data (First Time Only)

**Option A: Automatic (Recommended)**

```bash
python3 << EOF
import nltk
import ssl

# Fix SSL certificate issues on macOS
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

# Download Brown corpus
nltk.download('brown')
print("✓ NLTK data downloaded!")
EOF
```

**Option B: Manual (If SSL errors persist)**

```bash
# On macOS, run the certificate installer first:
/Applications/Python\ 3.*/Install\ Certificates.command

# Then download NLTK data:
python3 -c "import nltk; nltk.download('brown')"
```

### 5. Run the Backend Server

```bash
python3 main.py
```

You should see:

```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### 6. Test the API

**In your browser, open:**

- API Documentation: http://localhost:8000/docs
- Health Check: http://localhost:8000/

**Or test with curl:**

```bash
# Get daily challenge
curl http://localhost:8000/api/challenge/daily

# Get all challenges
curl http://localhost:8000/api/challenges

# Get user progress
curl http://localhost:8000/api/progress/1
```

### 5.5. Supabase Database Setup

The backend now uses Supabase PostgreSQL for persistent data storage.

#### Create Database Tables

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy and run the contents of `backend/database_setup.sql`

This creates the required tables:

- `user_progress` - Stores user XP, streaks, and completion stats
- `quiz_attempts` - Records individual quiz attempts with results

#### Configure Environment Variables

1. Copy the environment template:

```bash
cp .env.example .env
```

2. Get your Supabase credentials:

   - Go to **Settings** → **API** in your Supabase dashboard
   - Copy **Project URL** and **anon public key**

3. Edit `.env` and add:

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**Important:** Never commit the `.env` file to git.

### 7. Connect Flutter App to Backend

In your Flutter app, the API base URL should be:

- **For iOS Simulator:** `http://localhost:8000/api`
- **For Android Emulator:** `http://10.0.2.2:8000/api`
- **For Physical Device:** `http://YOUR_COMPUTER_IP:8000/api`

To find your computer's IP:

```bash
# On macOS/Linux:
ifconfig | grep "inet "

# On Windows:
ipconfig
```

### 8. Stop the Backend Server

Press `Ctrl+C` in the terminal where the server is running.

To deactivate the virtual environment:

```bash
deactivate
```

---

## 🔧 Project Structure

### Flutter App (`app/`)

- **`core/`** - Core files used throughout the app
  - Reusable widgets
  - Constants
  - Services (like Supabase client)
  - Configuration files
- **`features/`** - Individual app features, each containing:
  - `pages/` - Screen/page files
  - `widgets/` - Feature-specific widgets
  - `routes/` - Feature-specific routing

### Backend (`backend/`)

- **`main.py`** - FastAPI application entry point
- **`application/`** - API endpoints and request handling
  - `challenge_service.py` - Quiz and challenge endpoints
- **`domain/`** - Business logic (no external dependencies)
  - `challenge_logic.py` - Quiz logic, XP calculation
  - `models.py` - Data models
  - `utils/` - Reusable utilities (word generation, scrambling)
- **`infrastructure/`** - External services and data storage
  - `data_store.py` - In-memory storage (will be replaced with Supabase)

---

## 💡 Important Notes

### For Flutter Development:

- **Working Directory:** When you open the project in your IDE, make sure to navigate to the `app` folder first using `cd app`. This ensures the project runs correctly and reads all necessary files.
- **Questions?** If you have any doubts about the setup or project structure, contact a Team Leader or Manager.

### For Backend Development:

- **Always activate the virtual environment** before working on backend code
- **The backend must be running** for Flutter app features that depend on it (quiz, challenges)
- **Test your endpoints** using the Swagger UI at http://localhost:8000/docs
- **Code attribution:** Some utilities come from the QuizPython team. See `backend/CREDITS.md` for details.

---

## 🆘 Troubleshooting

### Flutter Issues

**App won't run / Configuration error:**

- Make sure you created `env.dart` from `env.example.dart`
- Verify you replaced the placeholder values with your actual Supabase credentials
- Check that your Supabase project is not paused in the dashboard

**Flutter command not found:**

- Make sure Flutter is installed and added to your PATH
- Run `flutter doctor` to diagnose issues

**Dependency errors:**

```bash
flutter clean
flutter pub get
flutter run
```

### Backend Issues

**SSL Certificate Error (macOS):**

```bash
# Run the certificate installer
/Applications/Python\ 3.*/Install\ Certificates.command

# Then try downloading NLTK data again
python3 -c "import nltk; nltk.download('brown')"
```

**ImportError: No module named 'nltk' (or other modules):**

```bash
# Make sure virtual environment is activated
source venv/bin/activate  # macOS/Linux
# or
venv\Scripts\activate  # Windows

# Reinstall dependencies
pip install -r requirements.txt
```

**Port 8000 already in use:**

```bash
# Find and kill the process using port 8000
# On macOS/Linux:
lsof -ti:8000 | xargs kill -9

# On Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

**Cannot connect Flutter app to backend:**

- Verify backend server is running (check terminal for "Uvicorn running" message)
- Check your API base URL in Flutter code
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For physical device, make sure phone and computer are on same WiFi network

**NLTK Brown corpus not found:**

```bash
# Download manually
python3 << EOF
import nltk
nltk.download('brown', quiet=False)
EOF
```

**"ModuleNotFoundError: No module named 'domain'" or similar:**

- Make sure you're running `python3 main.py` from the `backend/` directory
- Check that `__init__.py` files exist in all subdirectories

---

## 🔄 Daily Workflow

### Working on Flutter:

```bash
cd app
flutter run
# Make your changes
# Hot reload with 'r' in terminal
```

### Working on Backend:

```bash
cd backend
source venv/bin/activate  # Activate virtual environment
python3 main.py           # Start server
# Make your changes - server auto-reloads
# Test at http://localhost:8000/docs
deactivate                # When done
```

### Working on Both:

```bash
# Terminal 1 (Backend)
cd backend
source venv/bin/activate
python3 main.py

# Terminal 2 (Flutter)
cd app
flutter run
```

---

## 📚 Additional Resources

### Flutter:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)

### Backend:

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [NLTK Documentation](https://www.nltk.org/)
- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)

---

## 👥 Contributing

1. Create a new branch for your feature
2. Make your changes
3. Test thoroughly (both Flutter and backend if applicable)
4. Submit a pull request
5. Tag appropriate reviewers
