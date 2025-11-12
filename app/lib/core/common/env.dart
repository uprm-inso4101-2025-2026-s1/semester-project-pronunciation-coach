class Env {
  // Supabase Configuration
  // Get these values from your Supabase project dashboard:
  // https://supabase.com/dashboard/project/YOUR-PROJECT-ID/settings/api
  
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://enjnnnesbaqwtzrqfsbh.supabase.co',
  );
  
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVuam5ubmVzYmFxd3R6cnFmc2JoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NTI3NzksImV4cCI6MjA3NTMyODc3OX0.-rvIyWAp_8aWzi6pkkakscG5N41HoKPDkh0LIraKAIU',
  );
   //xAPI
  static const xApiBaseUrl = String.fromEnvironment('XAPI_BASE_URL', defaultValue: ''); //xAPI base url passed at runtime
  static const xApiKey  = String.fromEnvironment('XAPI_API_KEY',  defaultValue: '');// optional

  /// Validates that all required environment variables are configured.
  /// Throws a [StateError] if any required variables are missing.
  static void assertConfigured() {
    if (supabaseUrl.isEmpty || 
        supabaseUrl == 'https://your-project-id.supabase.co' ||
        supabaseAnonKey.isEmpty || 
        supabaseAnonKey == 'your-anon-key-here' ||
        xApiBaseUrl.isEmpty) {
      throw StateError(
        'Missing or invalid SUPABASE_URL or SUPABASE_ANON_KEY.\n'
        'Please follow the setup instructions in lib/core/common/README.md',
      );
    }
  }
}
