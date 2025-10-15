// loading_system/loading_factory.dart
import 'package:flutter/material.dart';
import 'loading_screens_core.dart';
import '../../../core/constants/colors.dart';

/// Factory Pattern: Loading Strategy Factory
class LoadingStrategyFactory {
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

  static LoadingStrategy createPulsatingWave({
    Color primaryColor = AppColors.primary,
    Color secondaryColor = AppColors.cardBackground,
  }) {
    return PulsatingWaveLoader(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

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