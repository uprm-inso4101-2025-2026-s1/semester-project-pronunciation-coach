import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/network/audio_api_service.dart';
import '../../state_machine/quiz_state_machine.dart';
import 'audio_quiz_home_page.dart';
import 'audio_quiz_question_page.dart';

class AudioQuizResultPage extends StatefulWidget {
  final AudioChallengeResult result;
  final Difficulty difficulty;
  final AudioChallenge challenge;

  const AudioQuizResultPage({
    super.key,
    required this.result,
    required this.difficulty,
    required this.challenge,
  });

  @override
  State<AudioQuizResultPage> createState() => _AudioQuizResultPageState();
}

class _AudioQuizResultPageState extends State<AudioQuizResultPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final QuizStateController _stateController = QuizStateController();
  bool _isPlayingCorrectAudio = false;
  StreamSubscription? _playerCompleteSubscription;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _playCorrectAudio() async {
    if (_isPlayingCorrectAudio) {
      await _audioPlayer.stop();
      setState(() {
        _isPlayingCorrectAudio = false;
      });
      return;
    }

    setState(() {
      _isPlayingCorrectAudio = true;
    });

    try {
      await _audioPlayer.stop();

      final audioUrl = widget.challenge.getAudioUrl(
        widget.result.correctAnswer,
      );

      _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _isPlayingCorrectAudio = false;
          });
        }
      });

      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlayingCorrectAudio = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play audio. Please try again.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _goToQuizHome(BuildContext context) {
    // Send go home event to state machine
    _stateController.sendEvent(GoHomeEvent());

    Navigator.popUntil(context, (route) {
      if (route is MaterialPageRoute &&
          route.builder(context) is AudioQuizHomePage) {
        return true;
      }
      return route.isFirst;
    });
  }

  Future<void> _retryQuiz(BuildContext context) async {
    // Send retry quiz event to state machine
    _stateController.sendEvent(RetryQuizEvent());

    try {
      final apiService = AudioApiService();
      final newChallenge = await apiService.generateAudioChallenge(
        widget.difficulty.id,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AudioQuizQuestionPage(
                  challenge: newChallenge,
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
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating new quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty.id) {
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

  IconData _getDifficultyIcon() {
    switch (widget.difficulty.id) {
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

  String _cleanDifficultyName(String name) {
    return name
        .replaceAll(
          RegExp(r'^(green|red|orange|blue|yellow)\s+', caseSensitive: false),
          '',
        )
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quiz Results',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildResultIcon(),
                              const SizedBox(height: 10),
                              _buildResultTitle(),
                              const SizedBox(height: 12),
                              _buildWordSection(),
                              const SizedBox(height: 12),
                              _buildXpSection(),
                              const SizedBox(height: 12),
                              _buildDifficultyBadge(),
                              const SizedBox(height: 16),
                              _buildActionButtons(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: widget.result.isCorrect
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.red.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.result.isCorrect ? Icons.check_circle : Icons.cancel,
        size: 50,
        color: widget.result.isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildResultTitle() {
    return Text(
      widget.result.isCorrect ? 'Correct!' : 'Incorrect',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: widget.result.isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildWordSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'The word was:',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          Text(
            widget.result.correctWord,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _playCorrectAudio,
            icon: Icon(
              _isPlayingCorrectAudio
                  ? Icons.stop_circle
                  : Icons.play_circle_filled,
              size: 22,
            ),
            label: Text(
              _isPlayingCorrectAudio
                  ? 'Stop Audio'
                  : 'Play Correct Pronunciation',
              style: const TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (!widget.result.isCorrect) ...[
            const SizedBox(height: 10),
            Text(
              'Correct answer: Option ${widget.result.correctAnswer}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildXpSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.3),
            Colors.orange.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.result.isCorrect ? 'XP Earned' : 'No XP Earned',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.result.xpEarned} XP',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    String cleanName = _cleanDifficultyName(widget.difficulty.name);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: _getDifficultyColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getDifficultyIcon(), size: 18, color: _getDifficultyColor()),
          const SizedBox(width: 8),
          Text(
            cleanName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _getDifficultyColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _goToQuizHome(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Home',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _retryQuiz(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
