import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/audio_api_service.dart';
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

class _AudioQuizResultPageState extends State<AudioQuizResultPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingCorrectAudio = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCorrectAudio() async {
    if (_isPlayingCorrectAudio) {
      // Stop if already playing
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
      
      final audioUrl = widget.challenge.getAudioUrl(widget.result.correctAnswer);
      
      print('🎵 Playing correct audio: $audioUrl');
      
      final completer = _audioPlayer.onPlayerComplete.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Audio playback timed out');
        },
      );
      
      await _audioPlayer.play(UrlSource(audioUrl));
      await completer;
      
      if (mounted) {
        setState(() {
          _isPlayingCorrectAudio = false;
        });
      }
    } catch (e) {
      print('❌ Audio error: $e');
      
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Result Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: widget.result.isCorrect
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.result.isCorrect
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 60,
                            color: widget.result.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Result Title
                        Text(
                          widget.result.isCorrect ? '🎉 Correct!' : '❌ Incorrect',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: widget.result.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Word Information with Play Button
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'The word was:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.result.correctWord,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Play Correct Audio Button
                              ElevatedButton.icon(
                                onPressed: _playCorrectAudio,
                                icon: Icon(
                                  _isPlayingCorrectAudio
                                      ? Icons.stop_circle
                                      : Icons.play_circle_filled,
                                  size: 24,
                                ),
                                label: Text(
                                  _isPlayingCorrectAudio
                                      ? 'Stop Audio'
                                      : 'Play Correct Pronunciation',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              
                              if (!widget.result.isCorrect) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Correct answer: Option ${widget.result.correctAnswer}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // XP Earned
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withOpacity(0.3),
                                Colors.orange.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.stars,
                                color: Colors.amber,
                                size: 36,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.result.isCorrect
                                        ? 'XP Earned'
                                        : 'No XP Earned',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${widget.result.xpEarned} XP',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Difficulty Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.difficulty.icon,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.difficulty.name} Level',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _getDifficultyColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AudioQuizHomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<void> _retryQuiz(BuildContext context) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final apiService = AudioApiService();
      final newChallenge =
          await apiService.generateAudioChallenge(widget.difficulty.id);

      // Close loading
      if (context.mounted) Navigator.pop(context);

      // Navigate to new quiz
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AudioQuizQuestionPage(
              challenge: newChallenge,
              difficulty: widget.difficulty,
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading
      if (context.mounted) Navigator.pop(context);

      // Show error
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
}
