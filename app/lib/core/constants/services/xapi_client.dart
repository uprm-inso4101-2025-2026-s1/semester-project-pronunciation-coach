import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../common/env.dart' as env;

/// xAPI (Experience API) client for sending learning analytics statements.
/// 
/// This client handles communication with an xAPI Learning Record Store (LRS)
/// to track user learning activities, progress, and interactions following
/// the xAPI specification standard.
class XApiClient {
  XApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Gets the xAPI statements endpoint URI from environment configuration
  Uri get _statementsUri => Uri.parse('${env.Env.xApiBaseUrl}/xapi/statements');

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
      if (env.Env.xApiKey.isNotEmpty)
        'Authorization': 'Bearer ${env.Env.xApiKey}',
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

  /// Performs a health check on the xAPI service endpoint.
  /// 
  /// This method checks if the xAPI backend service is reachable and responsive.
  /// Useful for testing connectivity and service status during app initialization
  /// or in diagnostic screens.
  /// 
  /// Returns [true] if the health endpoint returns 200 OK,
  /// [false] if the endpoint is unreachable or returns an error status.
  Future<bool> health() async {
    final uri = Uri.parse('${env.Env.xApiBaseUrl}/health');
    try {
      final res = await _client.get(uri);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
