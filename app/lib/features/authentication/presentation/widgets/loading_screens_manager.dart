// loading_system/loading_manager.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'loading_screens_core.dart';
import 'loading_screens_factory.dart';
import '../../../../core/common/colors.dart';

/// ===========================================================================
/// SINGLETON PATTERN + OBSERVER PATTERN + DECORATOR PATTERN
/// ===========================================================================
///
/// SINGLETON PATTERN:
/// - Ensures single instance of LoadingSystem across the app
/// - Global access point for loading functionality
/// - Consistent loading behavior throughout the application
///
/// OBSERVER PATTERN:
/// - Allows components to listen to loading state changes
/// - Decouples loading state management from UI components
/// - Supports multiple listeners for loading state
///
/// DECORATOR PATTERN:
/// - Enhances loading configuration with additional features
/// - Adds blur effects, custom backgrounds, and context-specific styling
/// - Extends functionality without modifying core loading logic
/// ===========================================================================

/// Main Loading System using Singleton, Observer and Decorator Patterns
class LoadingSystem {
  // SINGLETON IMPLEMENTATION
  static final LoadingSystem _instance = LoadingSystem._internal();
  factory LoadingSystem() => _instance;
  LoadingSystem._internal();

  // OBSERVER PATTERN: Loading state listeners
  final List<Function(bool)> _loadingListeners = [];

  /// DECORATOR PATTERN: Enhanced loading configuration
  /// Adds additional features (blur, custom background) to base loading strategy
  LoadingConfiguration _createEnhancedConfiguration(
    LoadingStrategy strategy,
    String context,
  ) {
    return LoadingConfiguration(
      strategy: strategy,
      context: context,
      backgroundColor: AppColors.cardBackground.withValues(alpha: 0.98),
      blurEffect: true, // Enhanced feature
    );
  }

  /// OBSERVER PATTERN: Add listener for loading state changes
  void addLoadingListener(Function(bool) listener) {
    _loadingListeners.add(listener);
  }

  /// OBSERVER PATTERN: Remove loading state listener
  void removeLoadingListener(Function(bool) listener) {
    _loadingListeners.remove(listener);
  }

  /// OBSERVER PATTERN: Notify all listeners of loading state change
  void _notifyLoadingListeners(bool isLoading) {
    for (final listener in _loadingListeners) {
      listener(isLoading);
    }
  }

  /// Show loading overlay with random strategy using FACTORY PATTERN
  void showLoading({
    required BuildContext context,
    required String message,
    String contextType = 'general',
    LoadingStrategy? customStrategy,
  }) {
    // FACTORY PATTERN: Create strategy (random or custom)
    final strategy =
        customStrategy ?? LoadingStrategyFactory.createRandomStrategy();

    // DECORATOR PATTERN: Enhance the configuration
    final config = _createEnhancedConfiguration(strategy, contextType);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) =>
          LoadingOverlay(configuration: config, message: message),
    );

    // OBSERVER PATTERN: Notify listeners
    _notifyLoadingListeners(true);
  }

  /// Hide loading overlay
  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    _notifyLoadingListeners(false);
  }
}

/// ===========================================================================
/// DECORATOR PATTERN: Enhanced Loading Configuration
/// ===========================================================================
///
/// PURPOSE:
/// - Wraps base loading strategy with additional features and styling
/// - Adds visual enhancements without modifying strategy implementations
/// - Provides context-specific customization options
///
/// ENHANCEMENTS:
/// - Custom background colors with opacity
/// - Blur effects for modern UI
/// - Context-based theming
/// ===========================================================================
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

/// ===========================================================================
/// Loading Overlay Widget
///
/// IMPLEMENTS:
/// - DECORATOR PATTERN: Applies enhanced configuration (blur, background)
/// - STRATEGY PATTERN: Delegates widget building to current strategy
/// ===========================================================================
class LoadingOverlay extends StatelessWidget {
  final LoadingConfiguration configuration;
  final String message;

  const LoadingOverlay({
    super.key,
    required this.configuration,
    required this.message,
  });

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
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4.h,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          // STRATEGY PATTERN: Delegate to current strategy
          child: configuration.strategy.buildLoadingWidget(context, message),
        ),
      ),
    );
  }
}
