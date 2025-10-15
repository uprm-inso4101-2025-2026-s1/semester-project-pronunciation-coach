// loading_system/loading_manager.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'loading_screens_core.dart';
import 'loading_screens_factory.dart';
import '../../../core/constants/colors.dart';

/// Main Loading System using Decorator and Observer Patterns
class LoadingSystem {
  static final LoadingSystem _instance = LoadingSystem._internal();
  factory LoadingSystem() => _instance;
  LoadingSystem._internal();

  // Observer pattern for loading state changes
  final List<Function(bool)> _loadingListeners = [];
  
  /// Decorator Pattern: Enhanced loading configuration
  LoadingConfiguration _createEnhancedConfiguration(LoadingStrategy strategy, String context) {
    return LoadingConfiguration(
      strategy: strategy,
      context: context,
      backgroundColor: AppColors.cardBackground.withOpacity(0.98),
      blurEffect: true,
    );
  }

  void addLoadingListener(Function(bool) listener) {
    _loadingListeners.add(listener);
  }

  void removeLoadingListener(Function(bool) listener) {
    _loadingListeners.remove(listener);
  }

  void _notifyLoadingListeners(bool isLoading) {
    for (final listener in _loadingListeners) {
      listener(isLoading);
    }
  }

  /// Show loading overlay with random strategy
  void showLoading({
    required BuildContext context,
    required String message,
    String contextType = 'general',
    LoadingStrategy? customStrategy,
  }) {
    final strategy = customStrategy ?? LoadingStrategyFactory.createRandomStrategy();
    final config = _createEnhancedConfiguration(strategy, contextType);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => LoadingOverlay(
        configuration: config,
        message: message,
      ),
    );
    
    _notifyLoadingListeners(true);
  }

  /// Hide loading overlay
  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    _notifyLoadingListeners(false);
  }
}

/// Decorator Pattern: Enhanced Loading Configuration
class LoadingConfiguration {
  final LoadingStrategy strategy;
  final String context;
  final Color backgroundColor;
  final bool blurEffect;

  const LoadingConfiguration({
    required this.strategy,
    required this.context,
    this.backgroundColor = Colors.white,
    this.blurEffect = false,
  });
}

/// Loading Overlay Widget
class LoadingOverlay extends StatelessWidget {
  final LoadingConfiguration configuration;
  final String message;

  const LoadingOverlay({
    Key? key,
    required this.configuration,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: configuration.blurEffect
            ? BackdropFilter(
                filter: const ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
                child: _buildContent(context),
              )
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.w),
          padding: EdgeInsets.all(4.h),
          decoration: BoxDecoration(
            color: configuration.backgroundColor,
            borderRadius: BorderRadius.circular(3.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.h,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: configuration.strategy.buildLoadingWidget(context, message),
        ),
      ),
    );
  }
}