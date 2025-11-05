
/// Sound effect asset paths and configuration constants
class SoundConstants {
  // Asset paths
  static const String loadingStart = 'core/sounds/loading/start.mp3';
  static const String loadingSuccess = 'core/sounds/loading/sucess.mp3';
  static const String strategyChange = 'core/sounds/loading/strategy_change.mp3';
  static const String factReveal = 'core/sounds/loading/fact_reveal.mp3';
  static const String buttonClick = 'core/sounds/UI/button_click.mp3';
  static const String transition = 'core/sounds/UI/transition.mp3';
  
  // Volume levels
  static const double defaultVolume = 100;
  static const double lowVolume = 0;
  static const double highVolume = 100;
  
  // Sound categories
  static const List<String> loadingSounds = [
    loadingStart,
    loadingSuccess,
    strategyChange,
    factReveal,
  ];
  
  static const List<String> uiSounds = [
    buttonClick,
    transition,
  ];
  
  // Sound durations (if known - for timing purposes)
  static const Duration loadingStartDuration = Duration(seconds: 3);
  static const Duration loadingSuccessDuration = Duration(seconds: 3);
  static const Duration strategyChangeDuration = Duration(seconds: 3);
}