// loading_system/loading_screens_core.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'loading_screens_widget.dart';
import 'loading_screens_facts.dart';

/// Strategy Pattern: Loading Behavior Interface
abstract class LoadingStrategy {
  Widget buildLoadingWidget(BuildContext context, String message);
  Duration get animationDuration;
  String getRandomFact();
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
      fact: getRandomFact(),
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 2000);

  @override
  String getRandomFact() => PronunciationFacts.getRandomFact();
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
      fact: getRandomFact(),
      stages: stages,
      currentStage: currentStage,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 2000);

  @override
  String getRandomFact() => PronunciationFacts.getRandomFact();
}

/// Concrete Strategy 3: Morphing Shape Loader
class MorphingShapeLoader implements LoadingStrategy {
  final Color shapeColor;
  final List<IconData> shapeSequence;
  
  MorphingShapeLoader({
    this.shapeColor = AppColors.primary,
    this.shapeSequence = const [
      Icons.volume_up,
      Icons.graphic_eq,
      Icons.waves,
      Icons.hearing,
      Icons.record_voice_over,
    ],
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return MorphingShapeWidget(
      message: message,
      fact: getRandomFact(),
      shapeColor: shapeColor,
      shapeSequence: shapeSequence,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 3000);

  @override
  String getRandomFact() => PronunciationFacts.getRandomFact();
}

/// Concrete Strategy 4: Text Typing Loader
class TextTypingLoader implements LoadingStrategy {
  final Color textColor;
  final List<String> messageSequence;
  
  TextTypingLoader({
    this.textColor = AppColors.textPrimary,
    this.messageSequence = const [
      "Processing your request",
      "Almost there",
      "Just a moment longer",
      "Finishing up",
    ],
  });

  @override
  Widget buildLoadingWidget(BuildContext context, String message) {
    return TextTypingWidget(
      message: message,
      fact: getRandomFact(),
      textColor: textColor,
      messageSequence: messageSequence,
    );
  }

  @override
  Duration get animationDuration => const Duration(milliseconds: 4000);

  @override
  String getRandomFact() => PronunciationFacts.getRandomFact();
}