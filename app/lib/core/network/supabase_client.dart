// app/lib/core/network/supabase_client.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/env.example.dart' as env;

class AppSupabase {
  static late final SupabaseClient client;

  static Future<void> init() async {
    // Ensure your Env is filled out.
    env.Env.assertConfigured();

    await Supabase.initialize(
      url: env.Env.supabaseUrl,
      anonKey: env.Env.supabaseAnonKey,
      // 2.10.x does not take a top-level `localStorage` parameter.
      // It already persists sessions for you.
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      debug: kDebugMode,
    );

    client = Supabase.instance.client;
  }
}
