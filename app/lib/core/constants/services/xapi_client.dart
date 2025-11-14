import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../common/env.example.dart';

class XApiClient {
  XApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri get _statementsUri => Uri.parse('${Env.xApiBaseUrl}/xapi/statements');

  /// Returns true on success, throws on non-2xx unless `silent` is true.
  Future<bool> sendStatement(
    Map<String, dynamic> statement, {
    bool silent = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (Env.xApiKey.isNotEmpty) 'Authorization': 'Bearer ${Env.xApiKey}',
    };

    try {
      final res = await _client.post(
        _statementsUri,
        headers: headers,
        body: jsonEncode(statement),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (kDebugMode) debugPrint('[xAPI] OK ${res.statusCode}: ${res.body}');
        return true;
      } else {
        if (kDebugMode) {
          debugPrint('[xAPI] ERROR ${res.statusCode}: ${res.body}');
        }
        if (!silent) {
          throw StateError('xAPI send failed: ${res.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[xAPI] EXCEPTION: $e');
      if (!silent) rethrow;
      return false;
    }
  }

  /// Optional: quick health check for your Testing Plan
  Future<bool> health() async {
    final uri = Uri.parse('${Env.xApiBaseUrl}/health');
    try {
      final res = await _client.get(uri);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
