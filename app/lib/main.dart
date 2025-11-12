import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/user_progress_dashboard.dart';
import 'features/dashboard/presentation/widgets/welcome_screen.dart';
import 'features/quiz/presentation/pages/audio_quiz_home_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'core/common/pace_selector.dart';
import 'core/network/supabase_client.dart';
import 'core/network/session_manager.dart';
import 'core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Terminal command to run with environment variables:
  // flutter run \
  // --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  // --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY

  try {
    await AppSupabase.init();
  } catch (e) {
    return;
  }

  await SessionManager.instance.start();

  // Setup dependency injection
  setupServiceLocator();

  runApp(
    ChangeNotifierProvider(create: (_) => MyAppState(), child: const MyApp()),
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

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    UserProgressDashboard(),
    AudioQuizHomePage(),
    ProfilePage(),
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
