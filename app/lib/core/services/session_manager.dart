import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'secure_storage_service.dart';
import 'supabase_client.dart';

/// Maneja persistencia de sesión, auto-refresh y logout seguro
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  final _storage = SecureStorageService.instance;
  final _sb = AppSupabase.get client; // tu helper existente
  StreamSubscription<AuthState>? _sub;
  Timer? _refreshTimer;

  /// Llamar una vez después de AppSupabase.init()
  Future<void> start() async {
    await _restorePersistedSession();
    _listenAuthChanges();
    _scheduleRefresh(_sb.auth.currentSession);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _refreshTimer?.cancel();
  }

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

  Future<void> _restorePersistedSession() async {
    final raw = await _storage.read(key: SecureStorageService.kPersistedSession);
    if (raw == null) return;

    try {
      final res = await _sb.auth.recoverSession(raw);
      final recovered = res.session;
      if (recovered != null) {
        await _persistSession(recovered);
      } else {
        await _clearPersistedSession();
      }
    } catch (_) {
      await _clearPersistedSession();
    }
  }

  Future<void> _persistSession(Session session) async {
    await _storage.write(
      key: SecureStorageService.kPersistedSession,
      value: session.persistSessionString,
    );
  }

  Future<void> _clearPersistedSession() async {
    await _storage.delete(key: SecureStorageService.kPersistedSession);
  }

  void _cancelRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

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

  Future<void> _attemptRefresh() async {
    try {
      final current = _sb.auth.currentSession;
      if (current == null) return;
      final refreshed = await _sb.auth.refreshSession();
      if (refreshed.session != null) {
        _scheduleRefresh(refreshed.session);
      }
    } catch (_) {
      await safeSignOut();
    }
  }

  Future<void> safeSignOut() async {
    _cancelRefresh();
    await _clearPersistedSession();
    await _sb.auth.signOut();
  }
}