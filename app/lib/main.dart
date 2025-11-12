import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// --- Feature imports ---
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/user_progress_dashboard.dart';
import 'features/dashboard/presentation/widgets/welcome_screen.dart';
import 'features/quiz/presentation/pages/audio_quiz_home_page.dart';
import 'core/common/pace_selector.dart';

// --- Core services ---
import 'core/network/supabase_client.dart';
import 'core/network/session_manager.dart';
import 'core/di/service_locator.dart';
import 'core/xapi/xapi_client.dart';
import 'core/xapi/xapi_provider.dart';

// --- App state ---
import 'core/state/my_app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // To run with required environment variables:
  // flutter run \
  // --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  // --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY \
  // --dart-define=XAPI_BASE_URL=https://your-backend.example.com/xapi

  // Initialize Supabase
  try {
    await AppSupabase.init();
  } catch (e) {
    // ignore: avoid_print
    print('Supabase init failed: $e');
    return; // Stop app if Supabase fails to init
  }

  // Initialize SessionManager
  await SessionManager.instance.start();

  // Initialize dependency injection
  setupServiceLocator();

  // Initialize xAPI client
  late final XApiClient xapi;
  try {
    xapi = await XApiClient.init();
  } catch (e) {
    // ignore: avoid_print
    print('XApi init failed: $e');
    xapi = XApiClient.degraded(); // continue in degraded mode
  }

  // Run app with multiple providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppState()),
        ChangeNotifierProvider(create: (_) => XApiProvider(xapi)),
      ],
      child: const MyApp(),
    ),
  );
}

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
          home: const WelcomeScreen(),
          routes: {
            '/login': (_) => const LoginPage(),
            '/dashboard': (_) => const MainNavigationScreen(),
            '/audio-quiz': (_) => const AudioQuizHomePage(),
            '/quiz': (_) => const AudioQuizHomePage(),
          },
        );
      },
    );
  }
}

// --- Navigation ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UserProgressDashboard(),
    const AudioQuizHomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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

// --- Profile page placeholder ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Profile Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
