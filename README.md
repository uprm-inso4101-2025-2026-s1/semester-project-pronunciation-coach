# Semester Project – Pronunciation Coach

A Flutter application for the course semester project.  
This repo has been initialized as a proper Flutter project so everyone can clone and run it immediately.

## 📋 Prerequisites

- Flutter SDK installed
- Git installed
- A Supabase account (free at [supabase.com](https://supabase.com))

**New to Flutter?** Check out these resources:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

## 🚀 Getting Started

### 1. Verify Your Setup

Run these commands to make sure Flutter is installed correctly:

```bash
flutter --version
flutter doctor
```

### 2. Clone the Repository

```bash
git clone https://github.com/<org-or-username>/semester-project-pronunciation-coach.git
cd semester-project-pronunciation-coach/app
flutter pub get
```

### 3. Environment Setup

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

### 4. Run the App

```bash
flutter run
```

Done! 🎉

> **Important:** The `env.dart` file is gitignored and stays on your machine only. Never commit it.

## 🔧 Project Structure

This project follows a structured organization pattern:

- **`core/`** - Core files used throughout the app
  - Reusable widgets
  - Constants
  - Services (like Supabase client)
  - Configuration files

- **`features/`** - Individual app features, each containing:
  - `pages/` - Screen/page files
  - `widgets/` - Feature-specific widgets
  - `routes/` - Feature-specific routing

This structure ensures efficiency and code organization.

## 💡 Important Notes

- **Working Directory:** When you open the project in your IDE, make sure to navigate to the `app` folder first using `cd app`. This ensures the project runs correctly and reads all necessary files.

- **Questions?** If you have any doubts about the setup or project structure, contact a Team Leader or Manager.

## 🆘 Troubleshooting

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