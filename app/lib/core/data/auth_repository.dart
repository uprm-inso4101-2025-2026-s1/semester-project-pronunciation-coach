// app/lib/core/data/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';

class AuthRepository {
  SupabaseClient get _sb => AppSupabase.client;

  /// Sign up and (if email-confirmation is OFF) create/update profile immediately.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final res = await _sb.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null && fullName.trim().isNotEmpty)
          'full_name': fullName.trim(),
      },
    );

    // If confirm email is OFF, session is present right now → safe to upsert.
    // If confirm email is ON, session is null; the trigger and/or later sign-in will complete profile setup.
    if (res.session != null && res.user != null) {
      try {
        await _sb.from('profiles').upsert({
          'id': res.user!.id,
          'email': res.user!.email,
          if (fullName != null && fullName.trim().isNotEmpty)
            'full_name': fullName.trim(),
        });
      } catch (_) {
        // Ignore if RLS blocks before confirmation.
      }
    }

    return res;
  }

  /// Email/password sign-in.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _sb.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => _sb.auth.signOut();
}
