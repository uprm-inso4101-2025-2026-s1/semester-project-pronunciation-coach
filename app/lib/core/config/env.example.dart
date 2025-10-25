class Env {
  // Supabase Configuration
  // Get these values from your Supabase project dashboard:
  // https://supabase.com/dashboard/project/YOUR-PROJECT-ID/settings/api
  
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-id.supabase.co',
  );
  
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here',
  );

  /// Validates that all required environment variables are configured.
  /// Throws a [StateError] if any required variables are missing.
  static void assertConfigured() {
    if (supabaseUrl.isEmpty || 
        supabaseUrl == 'https://your-project-id.supabase.co' ||
        supabaseAnonKey.isEmpty || 
        supabaseAnonKey == 'your-anon-key-here') {
      throw StateError(
        'Missing or invalid SUPABASE_URL or SUPABASE_ANON_KEY.\n'
        'Please follow the setup instructions in lib/core/config/README.md',
      );
    }
  }
}
