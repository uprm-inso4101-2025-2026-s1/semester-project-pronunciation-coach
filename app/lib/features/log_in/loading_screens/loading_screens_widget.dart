// loading_system/loading_screens_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import 'loading_screens_facts.dart';

/// ===========================================================================
/// TEMPLATE METHOD PATTERN: Base Loading Widget
/// ===========================================================================
///
/// PURPOSE:
/// - Defines the skeleton of loading widgets in base class
/// - Lets subclasses override specific steps without changing structure
/// - Provides common functionality (facts display, layout) to all loaders
///
/// TEMPLATE METHODS:
/// - build(): Defines overall widget structure (template)
/// - buildLoadingContent(): Abstract method for subclasses to implement (hook)
/// - _buildFactWidget(): Common functionality reused by all subclasses
/// ===========================================================================

abstract class BaseLoadingWidget extends StatefulWidget {
  final String message;
  final String? fact;

  const BaseLoadingWidget({super.key, required this.message, this.fact});

  /// =========================================================================
  /// TEMPLATE METHOD: Abstract hook for subclasses
  /// Subclasses must implement this to provide their specific loading content
  /// =========================================================================
  Widget buildLoadingContent(BuildContext context);

  @override
  BaseLoadingWidgetState createState();
}

abstract class BaseLoadingWidgetState<T extends BaseLoadingWidget>
    extends State<T> {
  String? currentFact;

  @override
  void initState() {
    super.initState();
    currentFact = widget.fact ?? PronunciationFacts.getRandomFact();
  }

  // Abstract method that subclasses must implement
  Widget buildLoadingContent(BuildContext context);

  /// =========================================================================
  /// TEMPLATE METHOD: Defines the overall widget structure
  /// This is the template that all loading widgets follow
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildLoadingContent(context),
          SizedBox(height: 3.h),
          if (currentFact != null) _buildFactWidget(),
        ],
      ),
    );
  }

  /// =========================================================================
  /// COMMON FUNCTIONALITY: Reused by all concrete loading widgets
  /// Demonstrates code reuse through Template Method Pattern
  /// =========================================================================
  Widget _buildFactWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.h),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pronunciation Tip',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            currentFact!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Pulsating Wave Animation Widget
class PulsatingWaveWidget extends BaseLoadingWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const PulsatingWaveWidget({
    super.key,
    required super.message,
    super.fact,
    this.primaryColor = AppColors.primary,
    this.secondaryColor = AppColors.cardBackground,
  });

  @override
  PulsatingWaveWidgetState createState() => PulsatingWaveWidgetState();

  @override
  Widget buildLoadingContent(BuildContext context) {
    return PulsatingWaveWidgetState().buildLoadingContent(context);
  }
}

class PulsatingWaveWidgetState
    extends BaseLoadingWidgetState<PulsatingWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildLoadingContent(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    widget.primaryColor.withValues(alpha: _animation.value),
                    widget.secondaryColor.withValues(
                      alpha: _animation.value * 0.3,
                    ),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  ...List.generate(4, (index) {
                    return Positioned.fill(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 2000 + (index * 300)),
                        margin: EdgeInsets.all(4.w * (1 - _animation.value)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.primaryColor.withValues(
                              alpha:
                                  0.4 *
                                  (1 - (_animation.value * (index + 1) / 5)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 8.w,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 3.h),
        Text(
          widget.message,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Progress Stages Widget
class ProgressStagesWidget extends BaseLoadingWidget {
  final List<String> stages;
  final Color activeColor;
  final Color inactiveColor;
  final int currentStage;

  const ProgressStagesWidget({
    super.key,
    required super.message,
    super.fact,
    required this.stages,
    this.currentStage = 0,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.textMuted,
  });

  @override
  ProgressStagesWidgetState createState() => ProgressStagesWidgetState();

  @override
  Widget buildLoadingContent(BuildContext context) {
    return ProgressStagesWidgetState().buildLoadingContent(context);
  }
}

class ProgressStagesWidgetState
    extends BaseLoadingWidgetState<ProgressStagesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildLoadingContent(BuildContext context) {
    return Column(
      children: [
        // Animated progress icon
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            color: widget.activeColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: widget.activeColor, width: 2),
          ),
          child: ScaleTransition(
            scale: _controller,
            child: Icon(
              Icons.trending_up,
              color: widget.activeColor,
              size: 8.w,
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // Progress stages
        Column(
          children: widget.stages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final isActive = index <= widget.currentStage;
            final isCurrent = index == widget.currentStage;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color: isActive
                          ? widget.activeColor
                          : widget.inactiveColor,
                      shape: BoxShape.circle,
                    ),
                    child: isCurrent
                        ? ScaleTransition(
                            scale: _controller,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.activeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      stage,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isActive
                            ? widget.activeColor
                            : widget.inactiveColor,
                        fontSize: 11.sp,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 3.h),
        Text(
          widget.message,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Morphing Shape Widget
class MorphingShapeWidget extends BaseLoadingWidget {
  final Color shapeColor;
  final List<IconData> shapeSequence;

  const MorphingShapeWidget({
    super.key,
    required super.message,
    super.fact,
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
  MorphingShapeWidgetState createState() => MorphingShapeWidgetState();

  @override
  Widget buildLoadingContent(BuildContext context) {
    return MorphingShapeWidgetState().buildLoadingContent(context);
  }
}

class MorphingShapeWidgetState
    extends BaseLoadingWidgetState<MorphingShapeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildLoadingContent(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final shapeIndex =
                (_animation.value * widget.shapeSequence.length).floor() %
                widget.shapeSequence.length;
            final progress =
                (_animation.value * widget.shapeSequence.length) % 1;

            return Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: widget.shapeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: widget.shapeColor, width: 2),
              ),
              child: Transform.scale(
                scale: 0.8 + 0.4 * progress,
                child: Icon(
                  widget.shapeSequence[shapeIndex],
                  size: 10.w,
                  color: widget.shapeColor,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 3.h),
        Text(
          widget.message,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Text Typing Widget
class TextTypingWidget extends BaseLoadingWidget {
  final Color textColor;
  final List<String> messageSequence;

  const TextTypingWidget({
    super.key,
    required super.message,
    super.fact,
    this.textColor = AppColors.textPrimary,
    this.messageSequence = const [
      "Processing your request",
      "Almost there",
      "Just a moment longer",
      "Finishing up",
    ],
  });

  @override
  TextTypingWidgetState createState() => TextTypingWidgetState();

  @override
  Widget buildLoadingContent(BuildContext context) {
    return TextTypingWidgetState().buildLoadingContent(context);
  }
}

class TextTypingWidgetState extends BaseLoadingWidgetState<TextTypingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _updateTextAnimation();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % widget.messageSequence.length;
        });
        _updateTextAnimation();
        _controller.reset();
        _controller.forward();
      }
    });
  }

  void _updateTextAnimation() {
    _textAnimation =
        IntTween(
          begin: 0,
          end: widget.messageSequence[_currentMessageIndex].length,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildLoadingContent(BuildContext context) {
    return Column(
      children: [
        // Animated typing indicator
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3.h),
            border: Border.all(color: AppColors.primary),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Icon(
                  Icons.keyboard,
                  size: 8.w,
                  color: AppColors.primary.withValues(
                    alpha: 0.6 + 0.4 * _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 3.h),
        AnimatedBuilder(
          animation: _textAnimation,
          builder: (context, child) {
            final currentText = widget.messageSequence[_currentMessageIndex]
                .substring(0, _textAnimation.value);

            return Column(
              children: [
                Text(
                  currentText,
                  style: AppTextStyles.heading3.copyWith(
                    color: widget.textColor,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
