import '../../../../core/common/quiz_attempt.dart';
import '../../../../core/network/progress_service.dart';

class QuizHistoryController {
  QuizHistoryController({ProgressService? progressService})
  : _progressServiceState = progressService ?? ProgressService();

  final ProgressService _progressServiceState;

  Future<QuizHistoryLoadResult> loadHistory({int limit = 50}) async {
    if (_progressServiceState.isGuest) {
      return const QuizHistoryLoadResult.guest();
    }

    try {
      final attempts = await _progressServiceState.getQuizAttempts(limit: limit);
      return QuizHistoryLoadResult.success(attempts);
    } catch (e) {
      throw Exception('Failed to load quiz history. $e');
    }
  }
}

class QuizHistoryLoadResult {
  final List<QuizAttempt> attempts;
  final bool isGuest;

  const QuizHistoryLoadResult._({
    required this.attempts,
    required this.isGuest,
  });

  const QuizHistoryLoadResult.guest() : attempts = const [], isGuest = true;

  factory QuizHistoryLoadResult.success(List<QuizAttempt> attempts) {
    return QuizHistoryLoadResult._(attempts: attempts, isGuest: false);
  }
}
