/// Environment configuration class for managing app configuration and secrets.
/// 
/// This class serves as both a template and runtime configuration manager.
/// Replace the default values with your actual credentials.
/// 
/// ⚠️ SECURITY NOTE: Never commit real credentials to version control.
class Env {
  // ==========================================
  // SUPABASE CONFIGURATION
  // ==========================================

  /// Supabase project URL
  /// 
  /// Get this value from your Supabase project dashboard:
  /// https://supabase.com/dashboard/project/YOUR-PROJECT-ID/settings/api
  /// 
  /// Expected format: 'https://your-project-id.supabase.co'
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xslhteoqlnvmrtphrhkg.supabase.co',
  );

  /// Supabase anonymous API key
  /// 
  /// Get this value from your Supabase project dashboard:
  /// https://supabase.com/dashboard/project/YOUR-PROJECT-ID/settings/api
  /// 
  /// This key is safe to use in client-side code but should still be kept secure.
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzbGh0ZW9xbG52bXJ0cGhyaGtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MzA3MzUsImV4cCI6MjA3ODMwNjczNX0.YSbDCpg35a5V49H5gckkMWhVL0vVfZICGr0GGqEZ8qU',
  );

  // ==========================================
  // XAPI CONFIGURATION
  // ==========================================

  /// xAPI backend service base URL
  /// 
  /// The base URL for your xAPI (Experience API) backend service.
  /// This is typically passed at runtime during build/execution.
  static const xApiBaseUrl = String.fromEnvironment(
    'XAPI_BASE_URL',
    defaultValue: 'https://your-backend.example.com/xapi',
  );

  /// xAPI service API key (optional)
  /// 
  /// API key for authenticating with the xAPI backend service.
  /// This is optional and may be empty if no authentication is required.
  static const xApiKey = String.fromEnvironment(
    'XAPI_API_KEY',
    defaultValue: '',
  );

  // ==========================================
  // VALIDATION METHODS
  // ==========================================

  /// Validates that all required environment variables are configured.
  /// 
  /// This method checks that Supabase credentials are properly set and not
  /// using the example/default values. It throws a [StateError] with
  /// helpful instructions if configuration is missing.
  /// 
  /// Validation is automatically skipped in:
  /// - CI environments (when `CI` environment variable is true)
  /// - Flutter test environments (when `FLUTTER_TEST` is true)
  /// 
  /// 🚨 Throws [StateError] if required Supabase credentials are missing or invalid.
  static void assertConfigured() {
    // Skip validation in CI/testing environments to allow builds and tests to run
    if (const bool.fromEnvironment('CI', defaultValue: false)) return;
    if (const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)) return;

    // Validate that Supabase credentials are properly configured
    final hasInvalidSupabaseUrl = supabaseUrl.isEmpty || 
        supabaseUrl == 'https://your-project-id.supabase.co';
    final hasInvalidSupabaseKey = supabaseAnonKey.isEmpty || 
        supabaseAnonKey == 'your-anon-key-here';

    if (hasInvalidSupabaseUrl || hasInvalidSupabaseKey) {
      throw StateError(
        'Missing SUPABASE credentials. Copy env.example.dart to env.dart and fill in real values.\n'
        'See setup instructions in lib/core/common/README.md',
      );
    }
  }
}
