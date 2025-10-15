// loading_system/loading_factory.dart
import 'package:flutter/material.dart';
import 'loading_screens_core.dart';
import '../../../core/constants/colors.dart';

/// Factory Pattern: Loading Strategy Factory
class LoadingStrategyFactory {
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
      'Validating',
      'Authenticating',
      'Loading',
      'Complete',
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
      Icons.circle,
      Icons.square,
      Icons.hexagon,
      Icons.ac_unit,
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
      "Validating credentials",
      "Authenticating user",
      "Loading profile",
      "Almost ready",
    ],
  }) {
    return TextTypingLoader(
      textColor: textColor,
      messageSequence: messageSequence,
    );
  }
}