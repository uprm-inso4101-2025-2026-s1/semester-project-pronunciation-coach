import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/user_progress_dashboard.dart';
import 'features/dashboard/presentation/widgets/welcome_screen.dart';
import 'features/quiz/presentation/pages/audio_quiz_home_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

import 'core/network/supabase_client.dart';
import 'core/network/session_manager.dart';
import 'core/di/service_locator.dart';
import 'core/constants/services/xapi_client.dart';
import 'core/constants/services/xapi_provider.dart';

/// ===========================================================================
/// MAIN APPLICATION
///
/// This file serves as the entry point for the Pronunciation Coach application.
/// It handles:
/// - Application initialization and dependency setup
/// - Error handling for configuration issues
/// - Provider setup for state management
/// - Navigation structure and routing
/// - Main application widget tree
///
/// KEY RESPONSIBILITIES:
/// - Environment configuration validation
/// - Supabase and xAPI client initialization
/// - Dependency injection setup
/// - Global state management with Provider
/// - Main navigation structure
/// ===========================================================================

/// Error Application Widget
///
/// Displays a user-friendly error screen when critical configuration fails.
/// Used when Supabase initialization fails due to missing environment variables.
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                const SizedBox(height: 24),
                Text(
                  'Configuration Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red[700]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Please set the required environment variables:\n'
                  'SUPABASE_URL and SUPABASE_ANON_KEY',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Application Entry Point
///
/// Initializes all required services and dependencies before running the app.
/// Handles critical failures gracefully by showing error screens.
Future<void> main() async {
  // Ensure Flutter binding is initialized before any platform calls
  WidgetsFlutterBinding.ensureInitialized();

  // Terminal command to run with environment variables:
  // flutter run \
  // --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  // --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY
  // --dart-define=XAPI_BASE_URL=https://your-backend.example.com/xapi

  // Initialize Supabase (required) - Critical dependency
  try {
    await AppSupabase.init();
  } catch (e) {
    // Show error screen instead of silently failing
    runApp(
      const ErrorApp(
        error:
            'Failed to initialize Supabase. Please check your environment configuration.',
      ),
    );
    return;
  }

  // Initialize xAPI client (optional - will use defaults if not configured)
  final XApiClient xapi = XApiClient.create();

  // Initialize session management
  await SessionManager.instance.start();

  // Setup dependency injection for service location
  setupServiceLocator();

  // Run main application with providers for state management
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => XApiNotifier(xapi))],
      child: const MyApp(),
    ),
  );
}

/// Main Application Widget
///
/// Root widget of the application that sets up:
/// - Global theme and styling
/// - Navigation routes
/// - Responsive design with Sizer
/// - Application title and configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Pronunciation Coach',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'SF Pro Display',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Start with welcome screen as initial route
          home: const WelcomeScreen(),
          // Named routes for navigation throughout the app
          routes: {
            '/login': (context) => const LoginPage(),
            '/dashboard': (context) => const MainNavigationScreen(),
            '/audio-quiz': (context) => const AudioQuizHomePage(),
            '/quiz': (context) => const AudioQuizHomePage(),
            '/settings': (context) => const SettingsPage(),
          },
        );
      },
    );
  }
}

/// Main Navigation Screen
///
/// Provides bottom navigation between main app sections:
/// - Home/Dashboard
/// - Audio Quiz
/// - User Profile
///
/// Uses a persistent bottom navigation bar for easy access to core features.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Main application pages corresponding to bottom navigation items
  final List<Widget> _pages = const [
    UserProgressDashboard(), // Home tab - Progress tracking
    AudioQuizHomePage(), // Quiz tab - Audio challenges
    ProfilePage(), // Profile tab - User information
  ];

  /// Handles bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the selected page based on navigation index
      body: _pages[_selectedIndex],
      // Bottom navigation bar with three main sections
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.headphones), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
