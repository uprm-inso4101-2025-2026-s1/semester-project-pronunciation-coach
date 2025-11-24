import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/network/audio_api_service.dart';
import '../../../../core/network/progress_service.dart';
import '../../../../core/common/quiz_attempt.dart';
import '../../domain/state_machine/quiz_state_machine.dart';
import 'audio_quiz_result_page.dart';

/// ===========================================================================
/// AUDIO QUIZ QUESTION PAGE
///
/// This file contains the main quiz interface where users:
/// - Listen to audio pronunciations
/// - Select their answer
/// - Submit and get immediate feedback
/// - Navigate to results
///
/// KEY FEATURES:
/// - Audio playback with visual feedback
/// - Answer selection with state management
/// - XP calculation and progress tracking
/// - Smooth animations and transitions
/// ===========================================================================

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

class _AudioQuizQuestionPageState extends State<AudioQuizQuestionPage>
    with SingleTickerProviderStateMixin {
  final AudioApiService _apiService = AudioApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final QuizStateController _stateController = QuizStateController();

  String? _selectedOption;
  String? _playingOption;
  bool _isSubmitting = false;
  String? _feedback;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isPlayingAudio = false;
  bool _autoPlayEnabled = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int get _userId {
    final user = Supabase.instance.client.auth.currentSession?.user;
    if (user != null) {
      return user.id.hashCode.abs();
    }
    return 1;
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
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    _setupAnimations();
    _loadAutoPlaySetting();
  }

  Future<void> _loadAutoPlaySetting() async {
    final prefs = await SharedPreferences.getInstance();
    _autoPlayEnabled =
        prefs.getBool('settings.autoplay_audio_enabled') ?? false;

    if (_autoPlayEnabled) {
      // Auto-play all options with delays
      Future.delayed(const Duration(milliseconds: 500), () => _startAutoPlay());
    }
  }

  Future<void> _startAutoPlay() async {
    if (!mounted || _hasAnswered) return;

    // Play each option sequentially (next plays immediately when current finishes)
    for (final option in widget.challenge.options) {
      if (!mounted || _hasAnswered) break;

      await _playAutoAudio(option.letter);
    }
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _audioPlayer.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Plays audio for autoplay and waits for completion (returns when finished)
  Future<void> _playAutoAudio(String optionLetter) async {
    if (_isPlayingAudio && _playingOption != null) {
      await _audioPlayer.stop();
    }

    if (!mounted || _hasAnswered) return;

    setState(() {
      _playingOption = optionLetter;
      _isPlayingAudio = true;
    });

    try {
      await _audioPlayer.stop();
      final audioUrl = widget.challenge.getAudioUrl(optionLetter);
      await _audioPlayer.play(UrlSource(audioUrl));

      // Wait for audio completion with timeout
      try {
        await _audioPlayer.onPlayerComplete.first.timeout(
          const Duration(seconds: 10),
        );
      } on TimeoutException {
        await _audioPlayer.stop();
      } catch (_) {
        await _audioPlayer.stop();
      }

      if (mounted) {
        setState(() {
          _playingOption = null;
          _isPlayingAudio = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _playingOption = null;
          _isPlayingAudio = false;
        });

        // Only show error for user-triggered audio, not auto-play
        if (!_autoPlayEnabled) {
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
  }

  /// Plays audio for the selected option with error handling and timeout
  Future<void> _playAudio(String optionLetter) async {
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

      try {
        await _audioPlayer.onPlayerComplete.first.timeout(
          const Duration(seconds: 10),
        );
      } on TimeoutException {
        await _audioPlayer.stop();
      } catch (_) {
        await _audioPlayer.stop();
      }

      if (mounted) {
        setState(() {
          _playingOption = null;
          _isPlayingAudio = false;
        });
      }
    } catch (_) {
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
          '${_cleanDifficultyName(widget.difficulty.name)} Quiz',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildChallengeCard(),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to hear each pronunciation:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.challenge.options.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final option = widget.challenge.options[index];
                      final isSelected = _selectedOption == option.letter;
                      final isPlaying = _playingOption == option.letter;

                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 400 + (index * 100)),
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
                        child: _AudioOptionCard(
                          option,
                          isSelected,
                          isPlaying,
                          _hasAnswered,
                          () => _playAudio(option.letter),
                          _hasAnswered
                              ? null
                              : () {
                                  setState(() {
                                    _selectedOption = option.letter;
                                    _feedback = null;
                                  });
                                  _stateController.sendEvent(
                                    SelectAnswerEvent(option.letter),
                                  );
                                },
                        ),
                      );
                    },
                  ),
                  if (_feedback != null) ...[
                    const SizedBox(height: 16),
                    _buildFeedbackCard(),
                  ],
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Displays the current challenge information and XP reward
  Widget _buildChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.headphones, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.challenge.content,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.stars, size: 16, color: Colors.amber[700]),
              const SizedBox(width: 6),
              Text(
                'Reward: ${widget.challenge.xpReward} XP',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows feedback after answer submission (correct/incorrect)
  Widget _buildFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isCorrect ? 'Great job!' : 'Try again next time!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _isCorrect ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Submit button that changes state based on quiz progress
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
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
                width: 22,
                height: 22,
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
    );
  }

  /// Submits the selected answer to the API and updates user progress
  Future<void> _submitAnswer() async {
    if (_selectedOption == null || _isSubmitting) return;

    // Send submit answer event to state machine
    _stateController.sendEvent(SubmitAnswerEvent());

    setState(() => _isSubmitting = true);

    try {
      final result = await _apiService.submitAudioAnswer(
        widget.challenge.id,
        _selectedOption!,
        _userId,
      );

      final xpMap = {"easy": 10, "medium": 15, "hard": 20};
      final baseXp = xpMap[widget.difficulty.id.toLowerCase()] ?? 15;
      final xpEarned = result.isCorrect ? baseXp : 0;

      final progressService = ProgressService();
      var progress = await progressService.getUserProgress();
      progress ??= await progressService.initializeUserProgress();

      final updatedProgress = progress.copyWith(
        totalXp: progress.totalXp + xpEarned,
        challengesCompleted: progress.challengesCompleted + 1,
        currentStreak: result.isCorrect ? progress.currentStreak + 1 : 0,
        lastChallengeDate: DateTime.now().toIso8601String().split('T')[0],
      );

      await progressService.saveUserProgress(updatedProgress);

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
      setState(() => _isSubmitting = false);
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

  /// Navigates to the results page after answer submission
  void _goToResults() async {
    // Send view results event to state machine
    _stateController.sendEvent(ViewResultsEvent());

    try {
      final result = await _apiService.submitAudioAnswer(
        widget.challenge.id,
        _selectedOption!,
        _userId,
      );

      if (mounted) {
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
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
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

/// Individual audio option card with play button and selection state
class _AudioOptionCard extends StatelessWidget {
  final AudioOption option;
  final bool isSelected;
  final bool isPlaying;
  final bool isDisabled;
  final VoidCallback onPlay;
  final VoidCallback? onSelect;

  const _AudioOptionCard(
    this.option,
    this.isSelected,
    this.isPlaying,
    this.isDisabled,
    this.onPlay,
    this.onSelect,
  );

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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
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
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onPlay,
                icon: Icon(
                  isPlaying ? Icons.stop_circle : Icons.play_circle_filled,
                  size: 36,
                  color: isPlaying ? Colors.red : AppColors.primary,
                ),
              ),
              const Expanded(child: SizedBox()),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
