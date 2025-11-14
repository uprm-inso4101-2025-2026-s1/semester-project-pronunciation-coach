import 'package:flutter/material.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/network/audio_api_service.dart';
import 'audio_quiz_question_page.dart';

class AudioQuizHomePage extends StatefulWidget {
  const AudioQuizHomePage({super.key});

  @override
  State<AudioQuizHomePage> createState() => _AudioQuizHomePageState();
}

class _AudioQuizHomePageState extends State<AudioQuizHomePage>
    with SingleTickerProviderStateMixin {
  final AudioApiService _apiService = AudioApiService();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Static difficulties - no need to fetch from backend
  final List<Difficulty> _difficulties = [
    Difficulty(
      id: 'easy',
      name: 'Easy',
      description:
          'Perfect for beginners. Simple words with clear pronunciations.',
      xpReward: 10,
      icon: 'sentiment_very_satisfied',
    ),
    Difficulty(
      id: 'medium',
      name: 'Medium',
      description:
          'Moderate challenge. Words with varying pronunciation patterns.',
      xpReward: 15,
      icon: 'sentiment_neutral',
    ),
    Difficulty(
      id: 'hard',
      name: 'Hard',
      description:
          'Expert level. Complex words requiring precise pronunciation.',
      xpReward: 20,
      icon: 'sentiment_very_dissatisfied',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildDifficultyList(),
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
        ..._difficulties.asMap().entries.map(
          (entry) => TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + (entry.key * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _DifficultyCard(
                difficulty: entry.value,
                onTap: () => _startQuiz(entry.value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startQuiz(Difficulty difficulty) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _QuizLoadingPage(difficulty: difficulty, apiService: _apiService),
      ),
    );
  }
}

class _QuizLoadingPage extends StatefulWidget {
  final Difficulty difficulty;
  final AudioApiService apiService;

  const _QuizLoadingPage({required this.difficulty, required this.apiService});

  @override
  State<_QuizLoadingPage> createState() => _QuizLoadingPageState();
}

class _QuizLoadingPageState extends State<_QuizLoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _loadingText = 'Preparing your quiz...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateQuiz();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  Future<void> _generateQuiz() async {
    try {
      // Update loading text
      setState(() {
        _loadingText = 'Generating challenge...';
      });

      // Generate the quiz challenge
      final challenge = await widget.apiService.generateAudioChallenge(
        widget.difficulty.id,
      );

      if (mounted) {
        setState(() {
          _loadingText = 'Almost ready...';
        });

        // Small delay for better UX
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          // Navigate to the actual quiz page with fade transition
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AudioQuizQuestionPage(
                    challenge: challenge,
                    difficulty: widget.difficulty,
                  ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Show error and go back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated quiz icon
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.quiz,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Loading text
              Text(
                _loadingText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Progress indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        return Icons.sentiment_very_satisfied;
      case 'medium':
        return Icons.sentiment_neutral;
      case 'hard':
        return Icons.sentiment_very_dissatisfied;
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
