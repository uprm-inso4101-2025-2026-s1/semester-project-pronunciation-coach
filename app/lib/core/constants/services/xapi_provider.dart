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

  /// Sends an xAPI statement to the Learning Record Store (LRS).
  /// 
  /// Delegates to the underlying [XApiClient.sendStatement] method while
  /// providing ChangeNotifier compatibility for reactive state management.
  /// 
  /// [statement]: A Map containing the xAPI statement data following the
  ///              xAPI specification format
  /// 
  /// Returns [Future<bool>] indicating success (true) or failure (false)
  /// of the statement submission.
  /// 
  /// Note: This method does not automatically notify listeners. If you need
  /// to trigger UI updates based on xAPI events, call notifyListeners() after
  /// successful statement submission.
  Future<bool> send(Map<String, dynamic> statement) =>
      _client.sendStatement(statement);
}
