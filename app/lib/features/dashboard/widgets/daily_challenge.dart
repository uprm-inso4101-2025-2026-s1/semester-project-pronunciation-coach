import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

// Simple challenge types
enum ChallengeType { name, word }

// Simple challenge data
class Challenge {
  final String content;
  final String? ipa;
  final String? hint;
  final ChallengeType type;
  final int xpReward;

  const Challenge({
    required this.content,
    this.ipa,
    this.hint,
    required this.type,
    required this.xpReward,
  });
}

// Simple challenge data
final List<Challenge> _challenges = [
  // Name challenges (20 XP)
  const Challenge(
    content: 'Christopher',
    ipa: '/ˈkrɪstəfər/',
    hint: 'Common English name',
    type: ChallengeType.name,
    xpReward: 20,
  ),
  const Challenge(
    content: 'Elizabeth',
    ipa: '/ɪˈlɪzəbəθ/',
    hint: 'Traditional English name',
    type: ChallengeType.name,
    xpReward: 20,
  ),
  // Word challenges (10 XP)
  const Challenge(
    content: 'Pronunciation',
    ipa: '/prəˌnʌnsiˈeɪʃən/',
    hint: 'The way words are spoken',
    type: ChallengeType.word,
    xpReward: 10,
  ),
  const Challenge(
    content: 'Beautiful',
    ipa: '/ˈbjuːtɪfəl/',
    hint: 'Pleasing to the eye',
    type: ChallengeType.word,
    xpReward: 10,
  ),
];

// Get random challenge
Challenge _getRandomChallenge() {
  final random = DateTime.now().millisecondsSinceEpoch % _challenges.length;
  return _challenges[random];
}

// Home screen widget
class DailyChallengeWidget extends StatelessWidget {
  final int currentStreak;
  final int totalXp;

  const DailyChallengeWidget({
    super.key,
    this.currentStreak = 0,
    this.totalXp = 0,
  });

  @override
  Widget build(BuildContext context) {
    final challenge = _getRandomChallenge();
    
    return GestureDetector(
      onTap: () => _navigateToChallenge(context, challenge),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Daily Challenge',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Challenge content
              Text(
                challenge.content,
                style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              ),
              if (challenge.ipa != null) ...[
                const SizedBox(height: 4),
                Text(
                  challenge.ipa!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                challenge.type == ChallengeType.name ? 'Name Challenge' : 'Word Challenge',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),

              const SizedBox(height: 16),

              // Bottom row with XP and streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // XP Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.amber, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: AppColors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '+${challenge.xpReward} XP',
                          style: TextStyle(
                            color: AppColors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Streak indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.danger, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: AppColors.danger, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$currentStreak day${currentStreak != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToChallenge(BuildContext context, Challenge challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyChallengeScreen(
          challenge: challenge,
          currentStreak: currentStreak,
          totalXp: totalXp,
        ),
      ),
    );
  }
}

// Challenge screen
class DailyChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final int currentStreak;
  final int totalXp;

  const DailyChallengeScreen({
    super.key,
    required this.challenge,
    this.currentStreak = 0,
    this.totalXp = 0,
  });

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  bool _isRecording = false;
  bool _hasSubmitted = false;
  bool _isSuccess = false;
  int _xpEarned = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Challenge', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Challenge content
            _buildChallengeContent(),
            const SizedBox(height: 24),

            // Result (if submitted)
            if (_hasSubmitted) ...[
              _buildResult(),
              const SizedBox(height: 24),
            ],

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.challenge.type == ChallengeType.name ? 'Name Challenge' : 'Word Challenge',
                style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${widget.challenge.xpReward} XP',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.challenge.type == ChallengeType.name 
                ? 'Pronounce the name correctly' 
                : 'Pronounce the word correctly',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip(Icons.star, 'Total XP', '${widget.totalXp}', AppColors.amber),
              const SizedBox(width: 12),
              _buildStatChip(Icons.local_fire_department, 'Streak', '${widget.currentStreak} days', AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pronounce this:',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Text(
            widget.challenge.content,
            style: AppTextStyles.heading1.copyWith(fontSize: 32, color: AppColors.textPrimary),
          ),
          if (widget.challenge.ipa != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
              ),
              child: Text(
                widget.challenge.ipa!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Play button
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _playAudio,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ),

          if (widget.challenge.hint != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.challenge.hint!,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isSuccess
              ? [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.05)]
              : [AppColors.danger.withOpacity(0.1), AppColors.danger.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isSuccess ? AppColors.success : AppColors.danger, width: 2),
      ),
      child: Column(
        children: [
          // Result badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _isSuccess ? AppColors.success : AppColors.danger,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_isSuccess ? Icons.check_circle : Icons.cancel, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isSuccess ? 'SUCCESS!' : 'TRY AGAIN',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // XP earned
          if (_xpEarned > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.amber, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: AppColors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '+$_xpEarned XP Earned!',
                    style: TextStyle(color: AppColors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Streak update
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.danger, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: AppColors.danger, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Streak: ${widget.currentStreak + (_isSuccess ? 1 : 0)} day${widget.currentStreak + (_isSuccess ? 1 : 0) != 1 ? 's' : ''}',
                  style: const TextStyle(color: AppColors.danger, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Record button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _hasSubmitted ? null : (_isRecording ? _stopRecording : _startRecording),
            icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
            label: Text(
              _isRecording ? 'Stop Recording' : 'Record Your Voice',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? AppColors.danger : AppColors.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: _isRecording ? 0 : 2,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _hasSubmitted ? null : _submitChallenge,
            icon: const Icon(Icons.send, color: Colors.white),
            label: const Text(
              'Submit Challenge',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ),

        // Try again button (if submitted)
        if (_hasSubmitted) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _resetChallenge,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _playAudio() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔊 Playing audio...'), duration: Duration(seconds: 1)),
    );
  }

  void _startRecording() {
    setState(() => _isRecording = true);
    HapticFeedback.mediumImpact();
  }

  void _stopRecording() {
    setState(() => _isRecording = false);
    HapticFeedback.lightImpact();
  }

  void _submitChallenge() {
    // Simulate random result
    final random = DateTime.now().millisecondsSinceEpoch % 2;
    setState(() {
      _hasSubmitted = true;
      _isSuccess = random == 0;
      _xpEarned = _isSuccess ? widget.challenge.xpReward : 0;
    });
    HapticFeedback.heavyImpact();
  }

  void _resetChallenge() {
    setState(() {
      _hasSubmitted = false;
      _isSuccess = false;
      _xpEarned = 0;
      _isRecording = false;
    });
  }
}
