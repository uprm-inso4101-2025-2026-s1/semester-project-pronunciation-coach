import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import 'package:app/features/log_in/pages/login_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Scale animation for the logo
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Fade animation for text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    // Slide animation for subtitle
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Color animation for background gradient
    _colorAnimation = ColorTween(
      begin: AppColors.primary.withOpacity(0.3),
      end: AppColors.primary,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Rotation animation for loading indicator
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.linear),
      ),
    );

    // Start animations
    _controller.forward();

    // Auto-navigate after 4 seconds with smooth transition
    Future.delayed(const Duration(seconds: 4), () {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated Logo Container
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.white.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(8.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow.withOpacity(0.5),
                            blurRadius: 4.w,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Main icon
                          Center(
                            child: Icon(
                              Icons.record_voice_over,
                              size: 25.w,
                              color: AppColors.primary,
                            ),
                          ),

                          // Pulsating circles
                          if (_controller.value > 0.5)
                            ..._buildPulsatingCircles(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Fade-in Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Pronunciation Coach',
                      style: AppTextStyles.welcomeTitle.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Slide-up Subtitle
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Master your pronunciation with personalized coaching',
                        style: AppTextStyles.welcomeSubtitle.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Simple rotating loading indicator
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: SizedBox(
                      width: 8.w,
                      height: 8.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.w,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPulsatingCircles() {
    return [
      // Outer circle
      if (_controller.value > 0.6)
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          builder: (context, value, child) {
            return Container(
              margin: EdgeInsets.all(8.w * value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3 * (1 - value)),
                  width: 2.0,
                ),
              ),
            );
          },
        ),

      // Middle circle
      if (_controller.value > 0.7)
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 0.6),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Container(
              margin: EdgeInsets.all(8.w * value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5 * (1 - value)),
                  width: 1.5,
                ),
              ),
            );
          },
        ),
    ];
  }
}
