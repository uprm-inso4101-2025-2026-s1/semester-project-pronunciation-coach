// loading_system/loading_system.dart
import 'package:flutter/material.dart';
import 'loading_screens_core.dart';
import '../../../../core/common/colors.dart';

/// ===========================================================================
/// LOADING SYSTEM - MAIN LOADING MANAGEMENT CLASS
/// ===========================================================================
/// 
/// PURPOSE:
/// - Centralized loading state management for the entire application
/// - Provides show/hide loading functionality with various strategies
/// - Implements Observer pattern for loading state notifications
/// - Uses Decorator pattern for enhanced loading configurations
/// 
/// DESIGN PATTERNS:
/// - SINGLETON: Single instance across the app
/// - OBSERVER: Notifies listeners of loading state changes
/// - DECORATOR: Enhances loading configurations with additional features
/// 
/// KEY FEATURES:
/// - Multiple loading strategies (wave, progress, morphing, typing)
/// - Customizable configurations (background, blur effects)
/// - State change notifications for UI updates
/// - Barrier dismissal control
/// ===========================================================================

/// Main Loading System using Decorator and Observer Patterns
class LoadingSystem {
  // SINGLETON PATTERN: Ensure single instance
  static final LoadingSystem _instance = LoadingSystem._internal();
  factory LoadingSystem() => _instance;
  LoadingSystem._internal();

  // OBSERVER PATTERN: Loading state change listeners
  final List<Function(bool)> _loadingListeners = [];

  /// DECORATOR PATTERN: Enhanced loading configuration
  /// Adds additional features like background color and blur effects
  LoadingConfiguration _createEnhancedConfiguration(
    LoadingStrategy strategy,
    String context,
  ) {
    return LoadingConfiguration(
      strategy: strategy,
      context: context,
      backgroundColor: AppColors.cardBackground.withValues(alpha: 0.95),
      blurEffect: true,
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

  /// Show loading overlay with specified strategy
  void showLoading({
    required BuildContext context,
    required LoadingStrategy strategy,
    required String message,
    String contextType = 'general',
  }) {
    // DECORATOR PATTERN: Create enhanced configuration
    final config = _createEnhancedConfiguration(strategy, contextType);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) =>
          _LoadingOverlay(configuration: config, message: message),
    );

    // OBSERVER PATTERN: Notify listeners of loading state
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
/// - Wraps base loading strategy with additional visual features
/// - Provides context-specific customization options
/// - Extends functionality without modifying core loading logic
/// 
/// ENHANCEMENTS:
/// - Custom background colors with opacity control
/// - Blur effects for modern UI appearance
/// - Context-based theming options
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
/// LOADING OVERLAY WIDGET
/// ===========================================================================
/// 
/// PURPOSE:
/// - Actual widget displayed during loading states
/// - Applies enhanced configuration from Decorator pattern
/// - Delegates content building to current strategy (Strategy pattern)
/// 
/// FEATURES:
/// - Non-dismissible overlay (barrierDismissible: false)
/// - Semi-transparent background
/// - Centered loading content with shadow effects
/// ===========================================================================
class _LoadingOverlay extends StatelessWidget {
  final LoadingConfiguration configuration;
  final String message;

  const _LoadingOverlay({required this.configuration, required this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: configuration.blurEffect
            ? BackdropFilter(
                filter: const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.srcOver,
                ),
                child: _buildContent(context),
              )
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: configuration.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // STRATEGY PATTERN: Delegate to current strategy
        child: configuration.strategy.buildLoadingWidget(context, message),
      ),
    );
  }
}