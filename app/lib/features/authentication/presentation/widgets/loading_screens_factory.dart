// loading_system/loading_factory.dart
import 'package:flutter/material.dart';
import 'loading_screens_core.dart';
import '../../../../core/common/colors.dart';

/// ===========================================================================
/// FACTORY PATTERN: Loading Strategy Factory
/// ===========================================================================
/// 
/// PURPOSE:
/// - Centralizes object creation logic for loading strategies
/// - Provides a simple interface to create different loading animations
/// - Encapsulates the complexity of strategy instantiation
/// - Supports both random and specific strategy creation
/// 
/// BENEFITS:
/// - Loose coupling: Client code doesn't need to know concrete classes
/// - Easy maintenance: Strategy creation logic in one place
/// - Extensibility: Easy to add new strategies without modifying client code
/// 
/// USAGE:
/// - Random strategy: LoadingStrategyFactory.createRandomStrategy()
/// - Specific strategy: LoadingStrategyFactory.createPulsatingWave()
/// ===========================================================================

class LoadingStrategyFactory {
  /// Creates a random loading strategy for variety and user engagement
  static LoadingStrategy createRandomStrategy() {
    final random = DateTime.now().millisecondsSinceEpoch % 4;
    switch (random) {
      case 0:
        return createPulsatingWave();
      case 1:
        return createProgressStages();
      case 2:
        return createMorphingShape();
      case 3:
        return createTextTyping();
      default:
        return createPulsatingWave();
    }
  }

  /// Factory method for Pulsating Wave strategy
  static LoadingStrategy createPulsatingWave({
    Color primaryColor = AppColors.primary,
    Color secondaryColor = AppColors.cardBackground,
  }) {
    return PulsatingWaveLoader(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

  /// Factory method for Progress Stages strategy
  static LoadingStrategy createProgressStages({
    List<String> stages = const [
      'Initializing',
      'Processing',
      'Validating',
      'Finalizing',
    ],
    int currentStage = 0,
    Color activeColor = AppColors.primary,
    Color inactiveColor = AppColors.textMuted,
  }) {
    return ProgressStagesLoader(
      stages: stages,
      currentStage: currentStage,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  /// Factory method for Morphing Shape strategy
  static LoadingStrategy createMorphingShape({
    Color shapeColor = AppColors.primary,
    List<IconData> shapeSequence = const [
      Icons.volume_up,
      Icons.graphic_eq,
      Icons.waves,
      Icons.hearing,
      Icons.record_voice_over,
    ],
  }) {
    return MorphingShapeLoader(
      shapeColor: shapeColor,
      shapeSequence: shapeSequence,
    );
  }

  /// Factory method for Text Typing strategy
  /// (Needs fix animation wise)
  static LoadingStrategy createTextTyping({
    Color textColor = AppColors.textPrimary,
    List<String> messageSequence = const [
      "Processing your request",
      "Almost there",
      "Just a moment longer",
      "Finishing up",
    ],
  }) {
    return TextTypingLoader(
      textColor: textColor,
      messageSequence: messageSequence,
    );
  }
}