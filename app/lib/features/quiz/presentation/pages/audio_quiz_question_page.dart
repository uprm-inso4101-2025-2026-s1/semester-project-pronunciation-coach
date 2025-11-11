import 'dart:async';
// ignore_for_file: prefer_conditional_assignment
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/network/audio_api_service.dart';
import '../../../../core/network/progress_service.dart';
import '../../../../core/common/quiz_attempt.dart';
import 'audio_quiz_result_page.dart';

class AudioQuizQuestionPage extends StatefulWidget {
  final AudioChallenge challenge;
  final Difficulty difficulty;

  const AudioQuizQuestionPage({
    super.key,
    required this.challenge,
    required this.difficulty,
  });

  @override
  State<AudioQuizQuestionPage> createState() => _AudioQuizQuestionPageState();
}

class _AudioQuizQuestionPageState extends State<AudioQuizQuestionPage> {
  final AudioApiService _apiService = AudioApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _selectedOption;
  String? _playingOption;
  bool _isSubmitting = false;
  String? _feedback;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isLoading = true;

  int get _userId {
    final user = Supabase.instance.client.auth.currentSession?.user;
    if (user != null) {
      // Convert Supabase UUID to int for backend compatibility
      return user.id.hashCode.abs();
    }
    // Fallback for guest users
    return 1;
  }

  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);

    // Simulate loading time for skeleton screen
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String optionLetter) async {
    // Stop any currently playing audio
    if (_isPlayingAudio && _playingOption != null) {
      await _audioPlayer.stop();
    }

    setState(() {
      _playingOption = optionLetter;
      _isPlayingAudio = true;
    });

    try {
      await _audioPlayer.stop();

      final audioUrl = widget.challenge.getAudioUrl(optionLetter);

      await _audioPlayer.play(UrlSource(audioUrl));

      // Wait for completion with timeout
      try {
        await _audioPlayer.onPlayerComplete.first.timeout(
          const Duration(seconds: 10),
        );
      } on TimeoutException {
        await _audioPlayer.stop();
      } catch (e) {
        await _audioPlayer.stop();
      }

      if (mounted) {
        setState(() {
          _playingOption = null;
          _isPlayingAudio = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _playingOption = null;
          _isPlayingAudio = false;
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
        title: Text(
          '${widget.difficulty.name} Quiz',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildSkeletonScreen()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Challenge information card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.headphones,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.challenge.content,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (widget.challenge.hint != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.challenge.hint!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              size: 18,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Reward: ${widget.challenge.xpReward} XP',
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
                  const SizedBox(height: 24),

                  Text(
                    'Tap to hear each pronunciation:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Audio option cards
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.challenge.options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final option = widget.challenge.options[index];
                        final isSelected = _selectedOption == option.letter;
                        final isPlaying = _playingOption == option.letter;

                        return _AudioOptionCard(
                          option: option,
                          isSelected: isSelected,
                          isPlaying: isPlaying,
                          isDisabled: _hasAnswered,
                          onPlay: () => _playAudio(option.letter),
                          onSelect: _hasAnswered
                              ? null
                              : () {
                                  setState(() {
                                    _selectedOption = option.letter;
                                    _feedback = null;
                                  });
                                },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Feedback message after answering
                  if (_feedback != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCorrect
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isCorrect ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect ? Colors.green : Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isCorrect
                                  ? 'Great job!'
                                  : 'Try again next time!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isCorrect
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedOption == null
                            ? Colors.grey[400]
                            : _hasAnswered
                            ? Colors.blue[400]
                            : Colors.green[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectedOption == null || _isSubmitting
                          ? null
                          : _hasAnswered
                          ? _goToResults
                          : _submitAnswer,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _hasAnswered ? 'View Results' : 'Submit Answer',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSkeletonScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skeleton for challenge information card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Skeleton for instruction text
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),

          // Skeleton for audio option cards
          Expanded(
            child: ListView.separated(
              itemCount: 4, // Assume 4 options
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Skeleton for submit button
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAnswer() async {
    if (_selectedOption == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get result from backend (validation and audio logic)
      final result = await _apiService.submitAudioAnswer(
        widget.challenge.id,
        _selectedOption!,
        _userId,
      );

      // Calculate XP based on difficulty
      final xpMap = {"easy": 10, "medium": 15, "hard": 20};
      final baseXp = xpMap[widget.difficulty.id.toLowerCase()] ?? 15;
      final xpEarned = result.isCorrect ? baseXp : 0;

      // Save progress data directly to Supabase
      final progressService = ProgressService();

      // Get or initialize user progress
      var progress = await progressService.getUserProgress();
      if (progress == null) {
        progress = await progressService.initializeUserProgress();
      }

      // Update progress based on result
      final updatedProgress = progress.copyWith(
        totalXp: progress.totalXp + xpEarned,
        challengesCompleted: progress.challengesCompleted + 1,
        currentStreak: result.isCorrect ? progress.currentStreak + 1 : 0,
        lastChallengeDate: DateTime.now().toIso8601String().split('T')[0],
      );

      await progressService.saveUserProgress(updatedProgress);

      // Save quiz attempt
      final attempt = QuizAttempt(
        userId: _userId,
        challengeId: widget.challenge.id,
        difficulty: widget.difficulty.id.toLowerCase(),
        userAnswer: _selectedOption!,
        correctAnswer: result.correctAnswer,
        isCorrect: result.isCorrect,
        xpEarned: xpEarned,
        createdAt: DateTime.now(),
      );

      await progressService.createQuizAttempt(attempt);

      setState(() {
        _isCorrect = result.isCorrect;
        _feedback = !result.isCorrect
            ? 'Correct answer: ${result.correctAnswer} - "${result.correctWord}"'
            : result.feedback;
        _hasAnswered = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting answer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToResults() async {
    // Show loading dialog while fetching result
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _apiService.submitAudioAnswer(
        widget.challenge.id,
        _selectedOption!,
        _userId,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Navigate to results page with fade transition
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AudioQuizResultPage(
                  result: result,
                  difficulty: widget.difficulty,
                  challenge: widget.challenge,
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
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading results: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _AudioOptionCard extends StatelessWidget {
  final AudioOption option;
  final bool isSelected;
  final bool isPlaying;
  final bool isDisabled;
  final VoidCallback onPlay;
  final VoidCallback? onSelect;

  const _AudioOptionCard({
    required this.option,
    required this.isSelected,
    required this.isPlaying,
    required this.isDisabled,
    required this.onPlay,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isDisabled ? null : onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Option letter indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    option.letter,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              IconButton(
                onPressed: onPlay,
                icon: Icon(
                  isPlaying ? Icons.stop_circle : Icons.play_circle_filled,
                  size: 40,
                  color: isPlaying ? Colors.red : AppColors.primary,
                ),
              ),

              const Expanded(child: SizedBox()),

              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
