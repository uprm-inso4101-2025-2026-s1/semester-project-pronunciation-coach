// loading_system/loading_screens_core.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'loading_screens_widget.dart';
import 'loading_screens_facts.dart';

/// ===========================================================================
/// STRATEGY PATTERN: Loading Behavior Interface
/// ===========================================================================
/// 
/// PURPOSE:
/// - Defines a family of interchangeable loading algorithms
/// - Encapsulates each loading behavior in separate classes
/// - Makes loading behaviors interchangeable at runtime
/// 
/// BENEFITS:
/// - Open/Closed Principle: Easy to add new strategies without modifying existing code
/// - Elimination of conditional logic for different loading types
/// - Runtime flexibility: Can switch strategies dynamically
/// 
/// IMPLEMENTATION:
/// - LoadingStrategy: Abstract interface for all loading behaviors
/// - Concrete strategies: PulsatingWaveLoader, ProgressStagesLoader, etc.
/// - Context: LoadingSystem uses strategies interchangeably
/// ===========================================================================

abstract class LoadingStrategy {
  Widget buildLoadingWidget(BuildContext context, String message);
  Duration get animationDuration;
  String getRandomFact();
}

/// ===========================================================================
/// CONCRETE STRATEGY 1: Pulsating Wave Loader
/// 
/// CHARACTERISTICS:
/// - Smooth pulsating wave animation with gradient effects
/// - Circular expansion/contraction patterns
/// - Medium animation duration (2000ms)
/// - Ideal for short to medium operations
/// ===========================================================================
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

/// ===========================================================================
/// CONCRETE STRATEGY 2: Progress Stages Loader
/// 
/// CHARACTERISTICS:
/// - Multi-stage progress indication
/// - Visual feedback for complex multi-step operations
/// - Step-by-step progression with active/inactive states
/// - Medium animation duration (2000ms)
/// ===========================================================================
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

/// ===========================================================================
/// CONCRETE STRATEGY 3: Morphing Shape Loader
/// 
/// CHARACTERISTICS:
/// - Dynamic shape transformation through icon sequences
/// - Smooth morphing animations between different shapes
/// - Longer animation duration (3000ms) for visual appeal
/// - Perfect for pronunciation-related contexts
/// ===========================================================================
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

/// ===========================================================================
/// CONCRETE STRATEGY 4: Text Typing Loader
/// 
/// CHARACTERISTICS:
/// - Simulated typing animation with changing messages
/// - Dynamic text progression for engaging user experience
/// - Longest animation duration (4000ms) for reading time
/// - Ideal for operations requiring user patience
/// ===========================================================================
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