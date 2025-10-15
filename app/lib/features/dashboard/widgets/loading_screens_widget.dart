// loading_system/loading_screens_widget.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

/// Pulsating Wave Animation Widget
class PulsatingWaveWidget extends StatefulWidget {
  final String message;
  final Color primaryColor;
  final Color secondaryColor;

  const PulsatingWaveWidget({
    Key? key,
    required this.message,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<PulsatingWaveWidget> createState() => PulsatingWaveWidgetState();
}

class PulsatingWaveWidgetState extends State<PulsatingWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    widget.primaryColor.withOpacity(_animation.value),
                    widget.secondaryColor.withOpacity(_animation.value * 0.5),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // Pulsating circles
                  ...List.generate(3, (index) {
                    return Positioned.fill(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 1500 + (index * 200)),
                        margin: EdgeInsets.all(20.0 * (1 - _animation.value)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.primaryColor.withOpacity(
                              0.3 * (1 - (_animation.value * (index + 1) / 4)),
                          ),
                        ),
                      ),
                    ),
                    );
                  }),
                  Center(
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          widget.message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Progress Stages Widget
class ProgressStagesWidget extends StatefulWidget {
  final String message;
  final List<String> stages;
  final int currentStage;
  final Color activeColor;
  final Color inactiveColor;

  const ProgressStagesWidget({
    Key? key,
    required this.message,
    required this.stages,
    required this.currentStage,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  @override
  State<ProgressStagesWidget> createState() => ProgressStagesWidgetState();
}

class ProgressStagesWidgetState extends State<ProgressStagesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Progress indicator
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isActive = index <= widget.currentStage;
              final isCurrent = index == widget.currentStage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    // Stage dot
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isActive ? widget.activeColor : widget.inactiveColor,
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
                    const SizedBox(height: 8),
                    // Stage label
                    Text(
                      stage,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isActive ? widget.activeColor : widget.inactiveColor,
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Morphing Shape Widget
class MorphingShapeWidget extends StatefulWidget {
  final String message;
  final Color shapeColor;
  final List<IconData> shapeSequence;

  const MorphingShapeWidget({
    Key? key,
    required this.message,
    required this.shapeColor,
    required this.shapeSequence,
  }) : super(key: key);

  @override
  State<MorphingShapeWidget> createState() => MorphingShapeWidgetState();
}

class MorphingShapeWidgetState extends State<MorphingShapeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final shapeIndex = (_animation.value * widget.shapeSequence.length).floor() % 
                widget.shapeSequence.length;
            final progress = (_animation.value * widget.shapeSequence.length) % 1;

            return Transform.scale(
              scale: 1.0 + 0.2 * progress,
              child: Opacity(
                opacity: 1.0 - progress,
                child: Icon(
                  widget.shapeSequence[shapeIndex],
                  size: 60,
                  color: widget.shapeColor,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          widget.message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Text Typing Widget
class TextTypingWidget extends StatefulWidget {
  final String baseMessage;
  final List<String> messageSequence;
  final Color textColor;

  const TextTypingWidget({
    Key? key,
    required this.baseMessage,
    required this.messageSequence,
    required this.textColor,
  }) : super(key: key);

  @override
  State<TextTypingWidget> createState() => TextTypingWidgetState();
}

class TextTypingWidgetState extends State<TextTypingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
    _updateTextAnimation();

    // Rotate through messages
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
    _textAnimation = IntTween(
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Typing cursor animation
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Icon(
                  Icons.keyboard,
                  size: 40,
                  color: AppColors.primary.withOpacity(
                    0.5 + 0.5 * _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _textAnimation,
          builder: (context, child) {
            final currentText = widget.messageSequence[_currentMessageIndex]
                .substring(0, _textAnimation.value);
            
            return Column(
              children: [
                Text(
                  currentText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: widget.textColor,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.baseMessage,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.0,
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