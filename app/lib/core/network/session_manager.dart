import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'secure_storage_service.dart';
import 'supabase_client.dart';
import 'dart:convert';

/// Manages user authentication sessions with persistence and automatic token refresh.
/// 
/// This singleton class handles the complete lifecycle of user sessions including:
/// - Session persistence across app restarts
/// - Automatic token refresh before expiration
/// - Secure storage of session data
/// - Auth state change monitoring
/// 
/// Implements the singleton pattern to ensure consistent session state across the app.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  final _storage = SecureStorageService.instance;
  final _sb = AppSupabase.client;
  StreamSubscription<AuthState>? _sub;
  Timer? _refreshTimer;

  /// Starts the session manager and initializes session handling.
  /// 
  /// This method should be called during app startup to:
  /// - Restore any previously persisted session from secure storage
  /// - Start listening for authentication state changes
  /// - Schedule automatic token refresh for the current session
  /// 
  /// Usage:
  /// ```dart
  /// await SessionManager.instance.start();
  /// ```
  Future<void> start() async {
    await _restorePersistedSession();
    _listenAuthChanges();
    _scheduleRefresh(_sb.auth.currentSession);
  }

  /// Stops the session manager and cleans up resources.
  /// 
  /// Cancels all active listeners and timers. Should be called when
  /// the app is closing or when session management is no longer needed.
  Future<void> stop() async {
    await _sub?.cancel();
    _refreshTimer?.cancel();
  }

  // ---------- Persistence ----------

  /// Restores a previously persisted session from secure storage.
  /// 
  /// Attempts to recover the session from encrypted storage and
  /// re-authenticate the user. If recovery fails, clears any invalid
  /// session data from storage.
  Future<void> _restorePersistedSession() async {
    try {
      final raw = await _storage.read(key: SecureStorageService.kPersistedSession);
      if (raw == null) return;

      final res = await _sb.auth.recoverSession(raw);
      final recovered = res.session;
      if (recovered != null) {
        await _persistSession(recovered);
        _scheduleRefresh(recovered);
      } else {
        await _clearPersistedSession();
      }
    } catch (_) {
      await _clearPersistedSession();
    }
  }

  /// Persists the current session to secure storage.
  /// 
  /// [session]: The Supabase session to persist, serialized as JSON
  /// for secure storage and later recovery.
  Future<void> _persistSession(Session session) async {
    final raw = jsonEncode(session.toJson());  // <- serialize Session
    await _storage.write(
      key: SecureStorageService.kPersistedSession,
      value: raw,
    );
  }

  /// Clears any persisted session data from secure storage.
  /// 
  /// Used during sign-out or when session data becomes invalid.
  Future<void> _clearPersistedSession() async {
    await _storage.delete(key: SecureStorageService.kPersistedSession);
  }

  // ---------- Auto-refresh ----------

  /// Listens for authentication state changes and manages session persistence.
  /// 
  /// Handles the following auth events:
  /// - Signed in: Persists new session and schedules refresh
  /// - Token refreshed: Updates persisted session and reschedules refresh
  /// - Signed out: Clears persisted session and cancels refresh
  void _listenAuthChanges() {
    _sub?.cancel();
    _sub = _sb.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        await _persistSession(session);
        _scheduleRefresh(session);
      } else if (event == AuthChangeEvent.tokenRefreshed && session != null) {
        await _persistSession(session);
        _scheduleRefresh(session);
      } else if (event == AuthChangeEvent.signedOut) {
        await _clearPersistedSession();
        _cancelRefresh();
      }
    });
  }

  /// Cancels any scheduled token refresh timer.
  void _cancelRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Schedules automatic token refresh before session expiration.
  /// 
  /// [session]: The current session to schedule refresh for
  /// 
  /// Calculates the optimal refresh time (60 seconds before expiration)
  /// and sets a timer to automatically refresh the token.
  void _scheduleRefresh(Session? session) {
    _cancelRefresh();
    if (session == null) return;

    final expiresAtSec = session.expiresAt;
    if (expiresAtSec == null) return;

    final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAtSec * 1000);
    final refreshAt = expiry.subtract(const Duration(seconds: 60));
    final now = DateTime.now();

    final delay = refreshAt.isAfter(now)
        ? refreshAt.difference(now)
        : const Duration(seconds: 1);

    _refreshTimer = Timer(delay, _attemptRefresh);
  }

  /// Attempts to refresh the current session token.
  /// 
  /// If refresh fails (e.g., network issues, invalid token),
  /// performs a safe sign-out to clear invalid session state.
  Future<void> _attemptRefresh() async {
    try {
      final current = _sb.auth.currentSession;
      if (current == null) return;

      final refreshed = await _sb.auth.refreshSession();
      _scheduleRefresh(refreshed.session ?? _sb.auth.currentSession);
    } catch (_) {
      await safeSignOut();
    }
  }

  /// Performs a safe sign-out with complete session cleanup.
  /// 
  /// This method ensures all session state is properly cleared:
  /// - Cancels refresh timers
  /// - Clears persisted session data
  /// - Signs out from Supabase auth
  /// 
  /// Use this instead of direct Supabase signOut for proper cleanup.
  Future<void> safeSignOut() async {
    _cancelRefresh();
    await _clearPersistedSession();
    await _sb.auth.signOut();
  }
}