import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

class AppSupabase {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    Env.assertConfigured();
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    _initialized = true;
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError('Call AppSupabase.init() before using the client.');
    }
    return Supabase.instance.client;
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSupabase.init();
  await SessionManager.instance.start(); // ← nuevo
  runApp(const MyApp());
}