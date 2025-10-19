class Env {
  //Passed at runtime via --dart-define
  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: ''); //currently supabase is paused, once unpaused will add url here
  static const supabaseAnonKey =
   
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''); //anon key is retrieved from settings(API) in Supabase
 /*to be able to run must use in terminal:
  flutter run \
  --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY

  supabase URL are not hardocoded for security reasons, keeping in mind future app structure and not leaving url hardcoded
 */
  static void assertConfigured() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL or SUPABASE_ANON_KEY (use --dart-define).',
      );
    }
  }
}
