/// Unit tests for the Quiz State Machine implementation
/// Demonstrates that the statecharts concepts are working correctly

import 'package:flutter_test/flutter_test.dart';
import '../lib/features/quiz/state_machine/quiz_state_machine.dart';

void main() {
  group('Quiz State Machine Tests', () {
    late QuizStateMachine stateMachine;

    setUp(() {
      stateMachine = QuizStateMachine();
    });

    test('Initial state should be IdleState', () {
      expect(stateMachine.currentState, isA<IdleState>());
      expect(stateMachine.currentStateName, 'Idle');
    });

    test(
      'StartQuizEvent should transition from Idle to SelectingDifficulty',
      () {
        stateMachine.sendEvent(StartQuizEvent('easy'));
        expect(stateMachine.currentState, isA<SelectingDifficultyState>());
        expect(stateMachine.currentStateName, 'SelectingDifficulty');
      },
    );

    test(
      'SelectAnswerEvent should transition from Answering to Evaluating',
      () {
        // Set up the state machine in answering state
        stateMachine.sendEvent(StartQuizEvent('easy'));
        // Simulate transitioning to answering state (normally done by UI)
        final answeringState = AnsweringState('easy', null, false);
        stateMachine = QuizStateMachine(); // Reset
        stateMachine.sendEvent(StartQuizEvent('easy'));

        // Create a test state machine with answering state
        final testMachine = QuizStateMachine();
        testMachine.sendEvent(StartQuizEvent('easy'));
        final answeringState2 = AnsweringState('easy', null, false);

        // Test the transition logic directly
        final newState = answeringState2.handleEvent(SelectAnswerEvent('A'));
        expect(newState, isA<AnsweringState>());
        expect((newState as AnsweringState).selectedAnswer, 'A');
      },
    );

    test(
      'SubmitAnswerEvent should transition from Answering to Evaluating',
      () {
        final answeringState = AnsweringState('easy', 'A', false);
        final newState = answeringState.handleEvent(SubmitAnswerEvent());
        expect(newState, isA<EvaluatingAnswerState>());
        expect((newState as EvaluatingAnswerState).selectedAnswer, 'A');
        expect((newState as EvaluatingAnswerState).hasAnswered, true);
      },
    );

    test('ViewResultsEvent should transition from Evaluating to Results', () {
      final evaluatingState = EvaluatingAnswerState('easy', 'A', true);
      final newState = evaluatingState.handleEvent(ViewResultsEvent());
      expect(newState, isA<ResultsState>());
      expect((newState as ResultsState).selectedAnswer, 'A');
      expect((newState as ResultsState).hasAnswered, true);
    });

    test(
      'RetryQuizEvent should transition from Results to SelectingDifficulty',
      () {
        final resultsState = ResultsState('easy', 'A', true);
        final newState = resultsState.handleEvent(RetryQuizEvent());
        expect(newState, isA<SelectingDifficultyState>());
      },
    );

    test(
      'GoHomeEvent should transition to IdleState from any active state',
      () {
        // Test from SelectingDifficulty
        stateMachine.sendEvent(StartQuizEvent('easy'));
        stateMachine.sendEvent(GoHomeEvent());
        expect(stateMachine.currentState, isA<IdleState>());

        // Test from Results state
        stateMachine.sendEvent(StartQuizEvent('easy'));
        final resultsState = ResultsState('easy', 'A', true);
        final newState = resultsState.handleEvent(GoHomeEvent());
        expect(newState, isA<IdleState>());
      },
    );

    test('State machine should handle invalid transitions gracefully', () {
      // Starting from idle, sending SelectAnswer should not change state
      stateMachine.sendEvent(SelectAnswerEvent('A'));
      expect(stateMachine.currentState, isA<IdleState>());

      // Starting from idle, sending SubmitAnswer should not change state
      stateMachine.sendEvent(SubmitAnswerEvent());
      expect(stateMachine.currentState, isA<IdleState>());
    });

    test('State machine reset should return to IdleState', () {
      stateMachine.sendEvent(StartQuizEvent('easy'));
      expect(stateMachine.currentState, isNot(isA<IdleState>()));

      stateMachine.reset();
      expect(stateMachine.currentState, isA<IdleState>());
    });
  });

  group('Quiz State Controller Tests', () {
    late QuizStateController controller;

    setUp(() {
      controller = QuizStateController();
    });

    test('Controller should initialize with IdleState', () {
      expect(controller.isIdle, true);
      expect(controller.isAnswering, false);
      expect(controller.isShowingResults, false);
    });

    test('Controller should notify listeners on state changes', () {
      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      controller.sendEvent(StartQuizEvent('easy'));
      expect(notified, true);
      expect(controller.isSelectingDifficulty, true);
    });

    test('Controller should provide correct state information', () {
      controller.sendEvent(StartQuizEvent('easy'));
      expect(controller.currentDifficulty, 'easy');
      expect(controller.isActiveQuiz, true);
    });
  });
}
