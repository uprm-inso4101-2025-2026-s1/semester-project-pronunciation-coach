/// Sound effect asset paths and configuration constants
class SoundConstants {
  // ===========================================================================
  // ASSET PATHS
  // ===========================================================================
  
  // ---------------------------------------------------------------------------
  // LOADING SOUNDS
  // Used during app loading states and initialization processes
  // ---------------------------------------------------------------------------
  static const String loadingStart = 'sounds/loading/start.mp3';        // Sound when app starts
  static const String loadingSuccess = 'sounds/loading/sucess.mp3';     // Sound when loading completes successfully
  static const String factReveal = 'sounds/loading/fact_reveal.mp3';    // Sound when revealing facts or tips in the loading screen
  
  // ---------------------------------------------------------------------------
  // UI SOUNDS
  // Used for user interface interactions and transitions
  // ---------------------------------------------------------------------------
  static const String strategyChange = 'sounds/UI/strategy_change.mp3'; // Sound when changing anything (Not implemented)
  static const String buttonClick = 'sounds/UI/button_click.mp3';       // Sound for button presses and taps (Not implemented)
  static const String transition = 'sounds/UI/transition.mp3';          // Sound for screen transitions and navigation
  
  // ---------------------------------------------------------------------------
  // QUIZ SOUNDS
  // Used for quiz feedback and answer validation
  // ---------------------------------------------------------------------------
  static const String correctAnswer = 'sounds/Quiz_Sounds/Correct.mp3'; // Sound when user selects correct answer (Not implemented)
  static const String wrongAnswer = 'sounds/Quiz_Sounds/Wrong.mp3';     // Sound when user selects incorrect answer (Not Implemented)

  // ---------------------------------------------------------------------------
  // BACKGROUND SOUNDS
  // Used for ambient audio in different app sections
  // ---------------------------------------------------------------------------
  static const String authBackground = 'sounds/background/authbackground.mp3'; // Background sound for authentication screens
  static const String homeBackground = 'sounds/background/homebackground.mp3'; // Background sound for home/main screens
  
  // ===========================================================================
  // VOLUME CONFIGURATION
  // ===========================================================================
  
  /// Default volume level for most sounds (70% volume)
  static const double defaultVolume = 0.7;
  
  /// Low volume level for subtle sounds or background audio (30% volume)
  static const double lowVolume = 0.3;
  
  /// High volume level for important notifications (100% volume)
  static const double highVolume = 1.0;
  
  /// Background music volume (20% volume - lower for ambient audio)
  static const double backgroundVolume = 0.2;
  
  // ===========================================================================
  // SOUND CATEGORIES
  // Grouped for batch operations and management
  // ===========================================================================
  
  /// All loading-related sounds for preloading or category management
  static const List<String> loadingSounds = [
    loadingStart,
    loadingSuccess,
    strategyChange, // Note: strategyChange is categorized here but stored in UI folder
    factReveal,
  ];
  
  /// All user interface interaction sounds
  static const List<String> uiSounds = [
    buttonClick,
    transition,
  ];
  
  /// All background sounds for ambient audio
  static const List<String> backgroundSounds = [
    authBackground,
    homeBackground,
  ];
  
  // ===========================================================================
  // SOUND DURATIONS
  // Known durations for timing and synchronization purposes
  // ===========================================================================
  
  /// Duration of the loading start sound (1 second)
  static const Duration loadingStartDuration = Duration(seconds: 1);
  
  /// Duration of the loading success sound (3 seconds)
  static const Duration loadingSuccessDuration = Duration(seconds: 3);
  
  /// Duration of the strategy change sound (2 seconds)
  static const Duration strategyChangeDuration = Duration(seconds: 2);
}