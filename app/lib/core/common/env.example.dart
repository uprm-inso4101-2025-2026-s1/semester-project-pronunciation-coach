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
  //xAPI
  static const xApiBaseUrl = String.fromEnvironment(
    'XAPI_BASE_URL',
    defaultValue: 'https://your-backend.example.com/xapi',
  ); //xAPI base url passed at runtime
  static const xApiKey = String.fromEnvironment(
    'XAPI_API_KEY',
    defaultValue: '',
  ); // optional

  /// Validates that all required environment variables are configured.
  /// Throws a [StateError] if any required variables are missing.
  static void assertConfigured() {
    // Skip validation in CI/testing environments
    if (const bool.fromEnvironment('CI', defaultValue: false)) return;
    if (const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)) return;

    // Normal validation for development
    if (supabaseUrl.isEmpty ||
        supabaseUrl == 'https://your-project-id.supabase.co' ||
        supabaseAnonKey.isEmpty ||
        supabaseAnonKey == 'your-anon-key-here') {
      throw StateError(
        'Missing SUPABASE credentials. Copy env.example.dart to env.dart and fill in real values.\n'
        'See setup instructions in lib/core/common/README.md',
      );
    }
  }
}
