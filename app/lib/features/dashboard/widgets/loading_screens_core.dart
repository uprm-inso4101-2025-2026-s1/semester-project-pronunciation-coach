// loading_system/loading_screens_core.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'loading_screens_widget.dart';

/// Strategy Pattern: Loading Behavior Interface
abstract class LoadingStrategy {
  Widget buildLoadingWidget(BuildContext context, String message);
  Duration get animationDuration;
}

/// Concrete Strategy 1: Pulsating Wave Loader
class PulsatingWaveLoader implements LoadingStrategy {
  final Color primaryColor;
  final Color secondaryColor;

  PulsatingWaveLoader({
    this.primaryColor = AppColors.primary,
    this.secondaryColor = AppColors.cardBackground,
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return PulsatingWaveWidget(
      message: message,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 1500);
}

/// Concrete Strategy 2: Progress Stages Loader
class ProgressStagesLoader implements LoadingStrategy {
  final List<String> stages;
  final Color activeColor;
  final Color inactiveColor;
  final int currentStage;

  ProgressStagesLoader({
    required this.stages,
    this.currentStage = 0,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textMuted,
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return ProgressStagesWidget(
      message: message,
      stages: stages,
      currentStage: currentStage,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 2000);
}

/// Concrete Strategy 3: Morphing Shape Loader
class MorphingShapeLoader implements LoadingStrategy {
  final Color shapeColor;
  final List<IconData> shapeSequence;

  MorphingShapeLoader({
    this.shapeColor = AppColors.primary,
    this.shapeSequence = const [
      Icons.circle,
      Icons.square,
      Icons.hexagon,
      Icons.ac_unit,
    ],
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return MorphingShapeWidget(
      message: message,
      shapeColor: shapeColor,
      shapeSequence: shapeSequence,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 1800);
}

/// Concrete Strategy 4: Text Typing Loader
class TextTypingLoader implements LoadingStrategy {
  final Color textColor;
  final List<String> messageSequence;

  TextTypingLoader({
    this.textColor = AppColors.textPrimary,
    this.messageSequence = const [
      "Validating credentials",
      "Authenticating user",
      "Loading profile",
      "Almost ready",
    ],
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return TextTypingWidget(
      baseMessage: message,
      messageSequence: messageSequence,
      textColor: textColor,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 2500);
}
