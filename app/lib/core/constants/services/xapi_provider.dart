import 'package:flutter/foundation.dart';
import 'xapi_client.dart';

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

