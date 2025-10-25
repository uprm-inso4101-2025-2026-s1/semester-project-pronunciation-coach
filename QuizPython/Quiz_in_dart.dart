import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VowelSwapQuizApp());
}

class VowelSwapQuizApp extends StatelessWidget {
  const VowelSwapQuizApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vowel Swap Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // ----- Config -----
  static const includeYAsVowel = true;
  static const vowels = includeYAsVowel ? 'aeiouy' : 'aeiou';
  static const labels = ['A', 'B', 'C', 'D'];

  // Tiny built-in list
  static const fallbackWords = <String>[
    'software','random','window','science','example','milestone',
    'battery','voltage','resistor','magnet','circle','physics',
    'apple','strawberry','cherry','banana','orange','grapefruit',
    'teacher','student','college','library','station','algorithm',
  ];

  final _rng = Random();
  final _tts = FlutterTts();

  String _word = '';
  Map<String, String> _options = {}; // label -> word (hidden in UI)
  String _answerLabel = '';
  int _wrongCount = 0;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _newRound();
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  void _newRound() {
    final w = _pickRandomWord();
    final built = _buildOptions(w);
    setState(() {
      _word = w;
      _options = built.$1;
      _answerLabel = built.$2;
      _wrongCount = 0;
    });
    _speakPromptAndOptions();
  }

  String _pickRandomWord() {
    return fallbackWords[_rng.nextInt(fallbackWords.length)];
  }

  // Return (labeledOptions, answerLabel)
  (Map<String, String>, String) _buildOptions(String correct) {
    final distractors = _makeDistractors(correct, 3);
    final shuffled = <String>[correct, ...distractors]..shuffle(_rng);
    final labeled = <String, String>{
      for (int i = 0; i < labels.length; i++) labels[i]: shuffled[i],
    };
    final answer = labeled.entries.firstWhere((e) => e.value == correct).key;
    return (labeled, answer);
  }

  List<String> _makeDistractors(String word, int n) {
    final seen = <String>{};
    int guard = 0;
    while (seen.length < n && guard < 500) {
      guard++;
      final m = _misspell(word);
      if (m != word) seen.add(m);
    }
    if (seen.isEmpty) {
      while (seen.length < n) {
        seen.add('${word}_${seen.length + 1}');
      }
    }
    return seen.toList();
  }

  String _misspell(String word) {
    final idxs = <int>[];
    for (int i = 0; i < word.length; i++) {
      if (_isVowel(word[i])) idxs.add(i);
    }
    if (idxs.isEmpty) return word;
    final k = [1, 2][min(idxs.length - 1, _rng.nextInt(2))];
    idxs.shuffle(_rng);
    final chosen = idxs.take(k).toList();

    final chars = word.split('');
    for (final i in chosen) {
      chars[i] = _swapVowel(chars[i]);
    }
    var out = chars.join();
    if (out == word && idxs.isNotEmpty) {
      final i = idxs[_rng.nextInt(idxs.length)];
      chars[i] = _swapVowel(chars[i]);
      out = chars.join();
    }
    return out;
  }

  bool _isVowel(String ch) => vowels.contains(ch.toLowerCase());

  String _swapVowel(String ch) {
    final lower = ch.toLowerCase();
    final choices = vowels.split('').where((v) => v != lower).toList();
    final r = choices[_rng.nextInt(choices.length)];
    return ch.toUpperCase() == ch ? r.toUpperCase() : r;
  }

  // ----- TTS -----
  Future<void> _speak(String text) async {
    if (_speaking) return;
    setState(() => _speaking = true);
    try {
      await _tts.stop();
      await _tts.speak(text);
    } finally {
      if (mounted) setState(() => _speaking = false);
    }
  }

  Future<void> _speakPromptAndOptions() async {
    // Updated phrasing here too
    final prompt = 'Choose the correct way of saying this word.';
    final opts = labels.map((lab) => '$lab. ${_options[lab]}').join('. ');
    await _speak('$prompt $opts.');
  }

  // ----- Actions -----
  Future<void> _onPick(String label) async {
    if (label == _answerLabel) {
      // Speak only "Correct!" per your request
      await _speak('Correct!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Correct! Attempts before correct: $_wrongCount'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) _newRound();
    } else {
      setState(() => _wrongCount += 1);
      // Reshuffle options (values remain hidden in UI)
      final built = _buildOptions(_word);
      setState(() {
        _options = built.$1;
        _answerLabel = built.$2;
      });
      await _speak('Try again.');
      await _speakPromptAndOptions();
    }
  }

  // ----- UI -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vowel Swap Quiz (TTS)'),
        actions: [
          IconButton(
            tooltip: 'Repeat',
            onPressed: _speaking ? null : _speakPromptAndOptions,
            icon: const Icon(Icons.volume_up),
          ),
          IconButton(
            tooltip: 'New word',
            onPressed: _speaking ? null : _newRound,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 👇 Updated on-screen text (now shows the word)
                  Text(
                    'Choose the correct way of saying $_word',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: labels.map((lab) {
                      return _LetterButton(
                        letter: lab,
                        onTap: _speaking ? null : () => _onPick(lab),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  Text(
                    'Wrong attempts so far: $_wrongCount',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.volume_up),
                    onPressed: _speaking ? null : _speakPromptAndOptions,
                    label: const Text('Repeat'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LetterButton extends StatelessWidget {
  final String letter;
  final VoidCallback? onTap;
  const _LetterButton({required this.letter, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(
          letter,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
