class Env {
  //Passed at runtime via --dart-define
  //Supabase
  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: ''); //currently supabase is paused, once unpaused will add url here
  static const supabaseAnonKey =
   
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''); //anon key is retrieved from settings(API) in Supabase
 /*to be able to run must use in terminal:
  flutter run \
  --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY
  --dart-define=XAPI_BASE_URL=https://your-backend.example.com/xapi

  supabase URL and xAPI URL are not hardcoded for security reasons, keeping in mind future app structure and not leaving url hardcoded
 */
 
 //xAPI
  static const xApiBaseUrl = String.fromEnvironment('XAPI_BASE_URL', defaultValue: ''); //xAPI base url passed at runtime
  static const xApiKey  = String.fromEnvironment('XAPI_API_KEY',  defaultValue: '');// optional

  static void assertConfigured() {
    final missingMessage = <String>[];

    if (supabaseUrl.isEmpty) missingMessage.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missingMessage.add('SUPABASE_ANON_KEY');
    if (xApiBaseUrl.isEmpty) missingMessage.add('XAPI_BASE_URL');
    // xApiKey is optional; add if you plan to require it:
    // if (xApiKey.isEmpty) missingMessage.add('XAPI_API_KEY');

    if (missingMessage.isNotEmpty) {
      throw StateError(
        'Missing required env: ${missing.join(', ')} (use --dart-define or --dart-define-from-file).',
      );
    }
  }
}
