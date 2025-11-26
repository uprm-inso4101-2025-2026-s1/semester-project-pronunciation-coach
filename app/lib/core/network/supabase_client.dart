// app/lib/core/network/supabase_client.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/env.dart'; // Changed back to env.example.dart for it to work

/// Main Supabase client wrapper for initializing and accessing Supabase services.
/// 
/// This class provides a centralized interface for Supabase initialization
/// and client access throughout the application. It handles the setup of
/// Supabase with proper configuration and environment variables.
class AppSupabase {
  /// Static Supabase client instance accessible throughout the application.
  /// 
  /// This client provides access to all Supabase features including:
  /// - Database operations (CRUD)
  /// - Authentication services
  /// - Real-time subscriptions
  /// - Storage management
  static late final SupabaseClient client;

  /// Initializes the Supabase client with environment configuration.
  /// 
  /// This method must be called during application startup before any
  /// Supabase operations are attempted. It performs the following:
  /// - Validates environment configuration
  /// - Initializes Supabase with URL and API key
  /// - Configures authentication options
  /// - Enables debug mode in development
  /// 
  /// Throws [StateError] if environment variables are not properly configured.
  /// 
  /// Usage:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await AppSupabase.init();
  ///   runApp(MyApp());
  /// }
  /// ```
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
