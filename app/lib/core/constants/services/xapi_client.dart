import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../common/env.example.dart' as env;

class XApiClient {
  // Private fields, follows encapsulation
  final Uri _baseEndpoint;
  final http.Client _client;
  final String? _apiKey;

  // Private named constructor
  // Forces controlled initialization
  XApiClient._internal({
    required Uri endpoint,
    required http.Client client,
    required String? apiKey,
  })  : _baseEndpoint = endpoint,
        _client = client,
        _apiKey = apiKey;

  // Public factory: encapsulates env.example lookup
  factory XApiClient.create({http.Client? client}) {
    final base = env.Env.xApiBaseUrl;
    if (base.isEmpty) {
      throw StateError("XAPI_BASE_URL not configured.");
    }

    return XApiClient._internal(
      endpoint: Uri.parse(base),
      client: client ?? http.Client(),
      apiKey: env.Env.xApiKey.isEmpty ? null : env.Env.xApiKey,
    );
  }

  // Private getter: building statement URI
  Uri get _statementUri => Uri.parse("${_baseEndpoint.toString()}/xapi/statements");

  // Public API: sending an xAPI statement
  Future<bool> sendStatement(
    Map<String, dynamic> statement, {
    bool silent = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (_apiKey != null) 'Authorization': 'Bearer $_apiKey',
    };

    try {
      final res = await _client.post(
        _statementUri,
        headers: headers,
        body: jsonEncode(statement),
      );

      final ok = res.statusCode >= 200 && res.statusCode < 300;

      if (!ok) {
        if (kDebugMode) {
          debugPrint('[xAPI] ERROR ${res.statusCode}: ${res.body}');
        }
        if (!silent) throw StateError('xAPI send failed');
      }

      if (kDebugMode && ok) {
        debugPrint('[xAPI] OK: ${res.statusCode}');
      }
      return ok;
    } catch (err) {
      if (kDebugMode) debugPrint('[xAPI] EXCEPTION: $err');
      if (!silent) rethrow;
      return false;
    }
  }

  // Public API: Health Check
  Future<bool> health() async {
    final uri = _baseEndpoint.replace(path: "health");
    try {
      final res = await _client.get(uri);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
