import 'package:flutter/material.dart';

/// ===========================================================================
/// QUIZ STATE MACHINE
///
/// This file implements a finite state machine (FSM) for managing quiz flow.
/// The state machine handles transitions between different quiz states and
/// ensures proper state management throughout the user journey.
///
/// STATE MACHINE FLOW:
/// Idle → SelectingDifficulty → LoadingQuiz → Answering → Evaluating → Results
///
/// Events trigger state transitions, and each state defines valid transitions.
/// ===========================================================================

/// ===========================================================================
/// CONDITION EVENT NETWORK (CEN) COMPONENTS
/// ===========================================================================

class Place {
  final String name;
  int marks;

  Place(this.name, {this.marks = 0});

  bool get isMarked => marks > 0;

  void mark() => marks++;
  void unmark() {
    if (marks > 0) marks--;
  }
}

class Transition {
  final String name;
  final List<Place> preConditions;
  final List<Place> postConditions;

  Transition(
    this.name, {
    required this.preConditions,
    required this.postConditions,
  });

  bool canFire() => preConditions.every((p) => p.isMarked);

  void fire() {
    if (!canFire()) return;
    for (final place in preConditions) place.unmark();
    for (final place in postConditions) place.mark();
  }
}

/// ===========================================================================

/// Base event class for state machine events
abstract class QuizEvent {}

/// Events that can trigger state transitions
class StartQuizEvent extends QuizEvent {
  final String difficulty;
  StartQuizEvent(this.difficulty);
}

class SelectAnswerEvent extends QuizEvent {
  final String answer;
  SelectAnswerEvent(this.answer);
}

class SubmitAnswerEvent extends QuizEvent {}

class ViewResultsEvent extends QuizEvent {}

class RetryQuizEvent extends QuizEvent {}

class GoHomeEvent extends QuizEvent {}

/// Base state class
abstract class QuizState {
  const QuizState();

  /// Handle an event and return the next state
  QuizState handleEvent(QuizEvent event);

  /// Get the current state's name for debugging
  String get name;
}

/// Idle state - initial state when app starts
class IdleState extends QuizState {
  const IdleState();

  @override
  String get name => 'Idle';

  @override
  QuizState handleEvent(QuizEvent event) {
    if (event is StartQuizEvent) {
      return SelectingDifficultyState(event.difficulty);
    }
    return this;
  }
}

/// Superstate for all active quiz states
abstract class ActiveQuizState extends QuizState {
  final String difficulty;

  const ActiveQuizState(this.difficulty);

  @override
  QuizState handleEvent(QuizEvent event) {
    if (event is GoHomeEvent) {
      return const IdleState();
    }
    return handleActiveEvent(event);
  }

  /// Handle events specific to active quiz states
  @protected
  QuizState handleActiveEvent(QuizEvent event) {
    // Default implementation - subclasses can override
    return this;
  }
}

/// State when user is selecting difficulty
class SelectingDifficultyState extends ActiveQuizState {
  const SelectingDifficultyState(super.difficulty);

  @override
  String get name => 'SelectingDifficulty';

  @override
  QuizState handleActiveEvent(QuizEvent event) {
    // This state would transition to loading when difficulty is selected
    // For now, we'll handle this in the UI layer
    return this;
  }
}

/// State when quiz is loading/generating
class LoadingQuizState extends ActiveQuizState {
  const LoadingQuizState(super.difficulty);

  @override
  String get name => 'LoadingQuiz';

  @override
  QuizState handleActiveEvent(QuizEvent event) {
    // This state would transition to answering when quiz is ready
    // For now, we'll handle this in the UI layer
    return this;
  }
}

/// Superstate for question-related states
abstract class QuestionState extends ActiveQuizState {
  final String? selectedAnswer;
  final bool hasAnswered;

  const QuestionState(super.difficulty, this.selectedAnswer, this.hasAnswered);

  @override
  QuizState handleActiveEvent(QuizEvent event) {
    if (event is SelectAnswerEvent && !hasAnswered) {
      return AnsweringState(difficulty, event.answer, false);
    }
    return handleQuestionEvent(event);
  }

  QuizState handleQuestionEvent(QuizEvent event);
}

/// State when user is answering a question
class AnsweringState extends QuestionState {
  const AnsweringState(
    super.difficulty,
    super.selectedAnswer,
    super.hasAnswered,
  );

  @override
  String get name => 'Answering';

  @override
  QuizState handleQuestionEvent(QuizEvent event) {
    if (event is SubmitAnswerEvent && selectedAnswer != null) {
      return EvaluatingAnswerState(difficulty, selectedAnswer!, true);
    }
    return this;
  }
}

/// State when answer is being evaluated
class EvaluatingAnswerState extends QuestionState {
  const EvaluatingAnswerState(
    super.difficulty,
    super.selectedAnswer,
    super.hasAnswered,
  );

  @override
  String get name => 'EvaluatingAnswer';

  @override
  QuizState handleQuestionEvent(QuizEvent event) {
    if (event is ViewResultsEvent) {
      return ResultsState(difficulty, selectedAnswer!, true);
    }
    return this;
  }
}

/// State when showing results
class ResultsState extends ActiveQuizState {
  final String selectedAnswer;
  final bool hasAnswered;

  const ResultsState(super.difficulty, this.selectedAnswer, this.hasAnswered);

  @override
  String get name => 'Results';

  @override
  QuizState handleActiveEvent(QuizEvent event) {
    if (event is RetryQuizEvent) {
      return SelectingDifficultyState(difficulty);
    }
    return super.handleActiveEvent(event);
  }
}

/// Main State Machine class
class QuizStateMachine {
  QuizState _currentState;

  /// CEN places for each state
  Place idlePlace = Place('Idle', marks: 1);
  Place selectingPlace = Place('SelectingDifficulty');
  Place loadingPlace = Place('LoadingQuiz');
  Place answeringPlace = Place('Answering');
  Place evaluatingPlace = Place('EvaluatingAnswer');
  Place resultsPlace = Place('Results');

  QuizStateMachine() : _currentState = const IdleState();

  /// Get the current state
  QuizState get currentState => _currentState;

  /// Update CEN marks to match current state
  void _updateMarks() {
    idlePlace.marks = isInState<IdleState>() ? 1 : 0;
    selectingPlace.marks = isInState<SelectingDifficultyState>() ? 1 : 0;
    loadingPlace.marks = isInState<LoadingQuizState>() ? 1 : 0;
    answeringPlace.marks = isInState<AnsweringState>() ? 1 : 0;
    evaluatingPlace.marks = isInState<EvaluatingAnswerState>() ? 1 : 0;
    resultsPlace.marks = isInState<ResultsState>() ? 1 : 0;
  }

  /// Send an event to the state machine
  void sendEvent(QuizEvent event) {
    final newState = _currentState.handleEvent(event);
    _currentState = newState;
    _updateMarks();
  }

  /// Check if we're in a specific state type
  bool isInState<T extends QuizState>() {
    return _currentState is T;
  }

  /// Get current state name for debugging
  String get currentStateName => _currentState.name;

  /// Reset to initial state
  void reset() {
    _currentState = const IdleState();
  }
}

/// State machine controller that integrates with Flutter
class QuizStateController extends ChangeNotifier {
  final QuizStateMachine _stateMachine = QuizStateMachine();

  QuizStateMachine get stateMachine => _stateMachine;

  void sendEvent(QuizEvent event) {
    _stateMachine.sendEvent(event);
    notifyListeners();
  }

  QuizState get currentState => _stateMachine.currentState;

  bool get isIdle => _stateMachine.isInState<IdleState>();
  bool get isSelectingDifficulty =>
      _stateMachine.isInState<SelectingDifficultyState>();
  bool get isLoadingQuiz => _stateMachine.isInState<LoadingQuizState>();
  bool get isAnswering => _stateMachine.isInState<AnsweringState>();
  bool get isEvaluating => _stateMachine.isInState<EvaluatingAnswerState>();
  bool get isShowingResults => _stateMachine.isInState<ResultsState>();
  bool get isActiveQuiz => _stateMachine.currentState is ActiveQuizState;

  String get currentDifficulty {
    final state = _stateMachine.currentState;
    if (state is ActiveQuizState) {
      return state.difficulty;
    }
    return '';
  }

  String? get selectedAnswer {
    final state = _stateMachine.currentState;
    if (state is QuestionState) {
      return state.selectedAnswer;
    }
    return null;
  }

  bool get hasAnswered {
    final state = _stateMachine.currentState;
    if (state is QuestionState) {
      return state.hasAnswered;
    }
    return false;
  }

  void reset() {
    _stateMachine.reset();
    notifyListeners();
  }
}
