import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

// Class for loading wordbank.json and providing random words.
class WordBank {
  WordBank._internal();
  static final WordBank _instance = WordBank._internal();
  factory WordBank() => _instance;

  Map<String, dynamic>? _data;
  final _random = Random();

  // Lets the UI know if the wordbank is already loaded.
  static bool get isInitialized => _instance._data != null;

  // Loads the wordbank JSON from assets.
  Future<void> load() async {
    if (_data != null) return; // already loaded

    final jsonStr = await rootBundle.loadString('assets/sounds/wordbank.json');
    _data = json.decode(jsonStr) as Map<String, dynamic>;

  }

  // Returns a random word (key from the JSON).
  String getRandomWord() {
    if (_data == null || _data!.isEmpty) {
      throw StateError('WordBank not loaded or empty');
    }
    final keys = _data!.keys.toList();
    final index = _random.nextInt(keys.length);
    return keys[index];
  }

  // Get all words if ever necessary.
  List<String> getAllWords() {
    if (_data == null) {
      throw StateError('WordBank not loaded');
    }
    return _data!.keys.toList();
  }
}