import 'package:flutter/foundation.dart';
import 'xapi_client.dart';

/// ChangeNotifier wrapper for XApiClient that integrates with Flutter's Provider pattern.
/// 
/// This class provides a reactive interface for sending xAPI statements
/// while maintaining compatibility with Flutter's state management ecosystem.
/// It wraps the XApiClient functionality and notifies listeners of state changes
/// when used in more complex scenarios involving UI updates.
class XApiNotifier with ChangeNotifier {
  XApiNotifier(this._client);

  final XApiClient _client;

  String? _lastError;
  String? get lastError => _lastError;

  Future<bool> send(Map<String, dynamic> statement) async {
    _lastError = null;
    final ok = await _client.sendStatement(statement, silent: true);
    if (!ok) {
      _lastError = "Failed to send xAPI statement.";
      notifyListeners();
    }
    return ok;
  }
}

