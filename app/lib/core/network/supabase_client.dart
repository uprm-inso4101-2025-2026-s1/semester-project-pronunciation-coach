// app/lib/core/network/supabase_client.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/env.dart'; // Changed back to env.dart

class AppSupabase {
  static late final SupabaseClient client;

  static Future<void> init() async {
    // Ensure your Env is filled out.
    Env.assertConfigured();

    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      debug: kDebugMode,
    );

    client = Supabase.instance.client;
  }
}
