import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/audio_api_service.dart';
import 'audio_quiz_question_page.dart';

class AudioQuizHomePage extends StatefulWidget {
  const AudioQuizHomePage({super.key});

  @override
  State<AudioQuizHomePage> createState() => _AudioQuizHomePageState();
}

class _AudioQuizHomePageState extends State<AudioQuizHomePage> {
  final AudioApiService _apiService = AudioApiService();
  List<Difficulty>? _difficulties;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDifficulties();
  }

  Future<void> _loadDifficulties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final difficulties = await _apiService.getDifficulties();
      setState(() {
        _difficulties = difficulties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Audio Pronunciation Quiz',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDifficulties,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : _difficulties == null || _difficulties!.isEmpty
          ? const Center(child: Text('No difficulties available'))
          : _buildDifficultyList(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error loading difficulties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDifficulties,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Choose Your Difficulty',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Listen to audio pronunciations and pick the correct one!',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 24),
        ..._difficulties!.map(
          (difficulty) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _DifficultyCard(
              difficulty: difficulty,
              onTap: () => _startQuiz(difficulty),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startQuiz(Difficulty difficulty) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final challenge = await _apiService.generateAudioChallenge(difficulty.id);

      if (mounted) Navigator.pop(context);

      if (mounted) {
        // Navigate to question page and wait for result
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AudioQuizQuestionPage(
              challenge: challenge,
              difficulty: difficulty,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final VoidCallback onTap;

  const _DifficultyCard({required this.difficulty, required this.onTap});

  Color get _color {
    switch (difficulty.id) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData get _icon {
    switch (difficulty.id) {
      case 'easy':
        return Icons.sentiment_satisfied;
      case 'medium':
        return Icons.sentiment_neutral;
      case 'hard':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Icon(_icon, size: 32, color: _color)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      difficulty.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.stars, size: 16, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          '${difficulty.xpReward} XP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: _color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
