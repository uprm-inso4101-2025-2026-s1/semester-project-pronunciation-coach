import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../common/env.example.dart' as env;

/// xAPI (Experience API) client for sending learning analytics statements.
/// 
/// This client handles communication with an xAPI Learning Record Store (LRS)
/// to track user learning activities, progress, and interactions following
/// the xAPI specification standard.
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
  /// Gets the xAPI statements endpoint URI from environment configuration
  //Uri get _statementsUri => Uri.parse('${env.Env.xApiBaseUrl}/xapi/statements');

  /// Sends an xAPI statement to the Learning Record Store (LRS).
  /// 
  /// This method sends learning activity data following the xAPI specification
  /// which typically includes actor (user), verb (action), and object (activity).
  /// 
  /// [statement]: A Map containing the xAPI statement data following the
  ///              xAPI specification format
  /// [silent]: If true, suppresses exceptions and returns false on failure.
  ///           If false, throws StateError on non-2xx responses.
  /// 
  /// Returns [true] on successful submission (2xx status code),
  /// [false] on failure when silent mode is enabled.
  /// 
  /// Throws [StateError] on non-2xx responses when silent mode is disabled.
  /// Throws underlying [http] or [json] exceptions on network/parsing errors.
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
  /// Performs a health check on the xAPI service endpoint.
  /// 
  /// This method checks if the xAPI backend service is reachable and responsive.
  /// Useful for testing connectivity and service status during app initialization
  /// or in diagnostic screens.
  /// 
  /// Returns [true] if the health endpoint returns 200 OK,
  /// [false] if the endpoint is unreachable or returns an error status.
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
