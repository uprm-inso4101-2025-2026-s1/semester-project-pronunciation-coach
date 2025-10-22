import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/audio_api_service.dart';
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
  final int _userId = 1;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String optionLetter) async {
    setState(() {
      _playingOption = optionLetter;
    });

    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();
    
      final audioUrl = widget.challenge.getAudioUrl(optionLetter);
    
      print('🎵 Playing audio from: $audioUrl');
    
      // Use UrlSource instead of deprecated play method
      await _audioPlayer.play(UrlSource(audioUrl));
    
      // Wait for completion
      await _audioPlayer.onPlayerComplete.first;
    
      if (mounted) {
        setState(() {
          _playingOption = null;
        });
      }
    } catch (e) {
      print('❌ Audio error: $e');
    
      if (mounted) {
        setState(() {
          _playingOption = null;
        });
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not play audio. Please try again.'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Challenge Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                        color: Colors.blue.withOpacity(0.1),
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
                      Icon(Icons.stars, size: 18, color: Colors.amber[700]),
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

            // Instructions
            Text(
              'Tap 🔊 to hear each pronunciation:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Audio Options
            Expanded(
              child: ListView.separated(
                itemCount: widget.challenge.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
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

            // Feedback
            if (_feedback != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _hasAnswered && _feedback!.contains('Correct')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasAnswered && _feedback!.contains('Correct')
                        ? Colors.green
                        : Colors.red,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasAnswered && _feedback!.contains('Correct')
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: _hasAnswered && _feedback!.contains('Correct')
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _feedback!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _hasAnswered && _feedback!.contains('Correct')
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                _selectedOption == null
                    ? '👆 Select an option to continue'
                    : '✅ Tap Submit to check your answer',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 16),

            // Submit Button
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

  Future<void> _submitAnswer() async {
    if (_selectedOption == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await _apiService.submitAudioAnswer(
        widget.challenge.id,
        _selectedOption!,
        _userId,
      );

      setState(() {
        _feedback = result.feedback;
        if (!result.isCorrect) {
          _feedback = '$_feedback\nCorrect answer: ${result.correctAnswer} - "${result.correctWord}"';
        }
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
    final result = await _apiService.submitAudioAnswer(
      widget.challenge.id,
      _selectedOption!,
      _userId,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AudioQuizResultPage(
            result: result,
            difficulty: widget.difficulty,
            challenge: widget.challenge,
          ),
        ),
      );
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
              // Option Letter
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.withOpacity(0.2),
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

              // Play Button
              IconButton(
                onPressed: onPlay,
                icon: Icon(
                  isPlaying ? Icons.stop_circle : Icons.play_circle_filled,
                  size: 40,
                  color: isPlaying ? Colors.red : AppColors.primary,
                ),
              ),

              const Expanded(child: SizedBox()),

              // Selection Indicator
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
