// loading_system/loading_system.dart
import 'package:flutter/material.dart';
import 'loading_screens_core.dart';
import '../../../core/constants/colors.dart';

/// Main Loading System using Decorator and Observer Patterns
class LoadingSystem {
  static final LoadingSystem _instance = LoadingSystem._internal();
  factory LoadingSystem() => _instance;
  LoadingSystem._internal();

  // Observer pattern for loading state changes
  final List<Function(bool)> _loadingListeners = [];

  /// Decorator Pattern: Enhanced loading configuration
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

  /// Show loading overlay with specified strategy
  void showLoading({
    required BuildContext context,
    required LoadingStrategy strategy,
    required String message,
    String contextType = 'general',
  }) {
    final config = _createEnhancedConfiguration(strategy, contextType);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) =>
          _LoadingOverlay(configuration: config, message: message),
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
        child: configuration.strategy.buildLoadingWidget(context, message),
      ),
    );
  }
}
