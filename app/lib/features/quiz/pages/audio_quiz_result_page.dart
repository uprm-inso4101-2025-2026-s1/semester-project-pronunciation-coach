import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/audio_api_service.dart';
import 'audio_quiz_home_page.dart'; // Import for navigation
import 'audio_quiz_question_page.dart';

// Note: Ensure AudioChallengeResult, Difficulty, and AudioChallenge are correctly defined in their respective files.

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
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Plays the correct word's audio or stops if already playing.
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
      
      final audioUrl = widget.challenge.getAudioUrl(widget.result.correctAnswer);
      
      // Set up completion listener to stop playing state
      _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _isPlayingCorrectAudio = false;
          });
        }
      });
      
      await _audioPlayer.play(UrlSource(audioUrl));
      
    } catch (e) {
      // Handle audio playback error
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

  // Navigates back to the main quiz home screen and shows the nav bar.
  void _goToQuizHome(BuildContext context) {
    // Pop all routes until the AudioQuizHomePage route is reached.
    // This assumes AudioQuizHomePage is the route where the main nav bar is visible.
    Navigator.popUntil(context, (route) {
      // Check if the route is a MaterialPageRoute and its builder creates an AudioQuizHomePage
      // This is a common pattern to stop at a known route type if named routes aren't used.
      if (route is MaterialPageRoute && route.builder(context) is AudioQuizHomePage) {
        return true;
      }
      // Fallback: If AudioQuizHomePage is the first route in this stack, this will return to it.
      // If it's not the first route of the entire app, you might need a named route reference.
      return route.isFirst;
    });
  }

  // Retries the quiz with a new challenge for the same difficulty.
  Future<void> _retryQuiz(BuildContext context) async {
    // Show loading indicator
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

      // Close loading indicator
      if (context.mounted) Navigator.pop(context);

      // Navigate to new quiz and replace the current result screen
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
      // Close loading indicator
      if (context.mounted) Navigator.pop(context);

      // Show error message
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
        // Hide the default back button since we control navigation with the 'Home' button.
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
                        // Result icon
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

                        // Result title text
                        Text(
                          // Removed emoji from text
                          widget.result.isCorrect ? 'Correct!' : 'Incorrect',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: widget.result.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Word and play button section
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

                        // XP display section
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
                    onPressed: () => _goToQuizHome(context), // Use the new function
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
}
