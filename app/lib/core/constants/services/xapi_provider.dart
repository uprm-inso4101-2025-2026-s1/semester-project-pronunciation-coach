import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'xapi_client.dart';

class XApiNotifier with ChangeNotifier {
  XApiNotifier(this._client);
  final XApiClient _client;

  Future<bool> send(Map<String, dynamic> statement) => _client.sendStatement(statement);
}
