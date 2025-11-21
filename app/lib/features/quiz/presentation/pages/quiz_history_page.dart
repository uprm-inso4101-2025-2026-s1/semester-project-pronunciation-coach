import 'package:flutter/material.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/quiz_attempt.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/quiz_history_widgets.dart';
import '../../../../core/common/colors.dart' as common_colors;

class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  final QuizHistoryController _controller = QuizHistoryController();
  late Future<QuizHistoryLoadResult> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<QuizHistoryLoadResult> _loadHistory() {
    return _controller.loadHistory(limit: 50);
  }

  Future<void> _refreshHistory() async {
    setState(() {
      _historyFuture = _loadHistory();
    });
    await _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quiz History',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<QuizHistoryLoadResult>(
        future: _historyFuture,
        builder: (context, e) {
          if (e.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (e.hasError) {
            return findHistoryError(
              message:
                  e.error?.toString() ??
                  'Something went wrong while loading your quizzes.',
              onRetry: _refreshHistory,
            );
          }

          final result = e.data;
          if (result == null) {
            return findHistoryError(
              message: 'Unable to load quiz history.',
              onRetry: _refreshHistory,
            );
          }

          if (result.isGuest) {
            return GuestHistoryPlaceholder(
              onActionPressed: () {
                Navigator.pop(context);
              },
            );
          }

          final attempts = List<QuizAttempt>.from(result.attempts)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (attempts.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 120), atEmptyHistory()],
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _HistoryInsights(attempts: attempts),
              const SizedBox(height: 20),
              const Text(
                'Recent Attempts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              for (final attempt in attempts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuizAttemptContainer(attempt: attempt),
                ),
              const SizedBox(height: 8),
              Text(
                'Showing last ${attempts.length} quizzes',
                style: TextStyle(
                  color: AppColors.textMuted.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryInsights extends StatelessWidget {
  final List<QuizAttempt> attempts;

  const _HistoryInsights({required this.attempts});

  @override
  Widget build(BuildContext context) {
    final accuracy = attempts.isEmpty
        ? 0
        : ((attempts.where((a) => a.isCorrect).length / attempts.length) * 100)
              .round();
    final totalXp = attempts.fold<int>(0, (sum, a) => sum + a.xpEarned);
    final mostRecent = attempts.first;
    final best = findBestAttempt(attempts);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InsightStat(
                  title: 'Accuracy',
                  value: '$accuracy%',
                  icon: Icons.bolt,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InsightStat(
                  title: 'Total XP',
                  value: '$totalXp',
                  icon: Icons.stars,
                  color: Colors.amber[700]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InsightStat(
                  title: 'Attempts',
                  value: '${attempts.length}',
                  icon: Icons.history,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: HighlightCard(
                  title: 'Most Recent',
                  attempt: mostRecent,
                  icon: Icons.update,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HighlightCard(
                  title: 'Top Score',
                  attempt: best ?? mostRecent,
                  icon: Icons.emoji_events,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static QuizAttempt? findBestAttempt(List<QuizAttempt> attempts) {
    if (attempts.isEmpty) {
      return null;
    }

    return attempts.reduce((prev, current) {
      if (current.xpEarned == prev.xpEarned) {
        return current.createdAt.isAfter(prev.createdAt) ? current : prev;
      }
      return current.xpEarned > prev.xpEarned ? current : prev;
    });
  }
}

class QuizAttemptContainer extends StatelessWidget {
  final QuizAttempt attempt;

  const QuizAttemptContainer({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final statusColor = attempt.isCorrect
        ? AppColors.success
        : AppColors.danger;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatHistoryDate(attempt.createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AssignDificulty(difficulty: attempt.difficulty),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                attempt.isCorrect ? Icons.check_circle : Icons.cancel,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  attempt.isCorrect ? 'Correct answer' : 'Incorrect answer',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${attempt.xpEarned} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class AssignDificulty extends StatelessWidget {
  final String difficulty;

  const AssignDificulty({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(difficulty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        capitalizeDifficulty(difficulty),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class findHistoryError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const findHistoryError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class atEmptyHistory extends StatelessWidget {
  const atEmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, color: AppColors.textMuted, size: 48),
        const SizedBox(height: 12),
        const Text(
          'Quiz History empty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete your first quiz to see it here.',
          style: TextStyle(
            color: AppColors.textMuted.withValues(alpha: 0.9),
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GuestHistoryPlaceholder extends StatelessWidget {
  final VoidCallback onActionPressed;

  const GuestHistoryPlaceholder({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: AppColors.textMuted, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Sign In to track quizzes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create an account or sign in to save your quiz attempts.',
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.9),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign In / Create Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: common_colors.AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
