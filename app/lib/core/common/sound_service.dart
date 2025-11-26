import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'sound_constants.dart';

/// Sound Service - Centralized audio management for the application
///
/// This service provides a singleton instance for playing sound effects
/// throughout the app, with volume control and sound toggle functionality.
///
/// Features:
/// - Singleton pattern for consistent audio state
/// - Sound effect categorization (Loading, UI, Quiz)
/// - Volume management with preset levels
/// - Global sound enable/disable toggle
/// - Error handling for audio playback
class SoundService {
  // ===========================================================================
  // SINGLETON PATTERN
  // ===========================================================================

  /// Private singleton instance
  static final SoundService _instance = SoundService._internal();

  /// Factory constructor returns the singleton instance
  factory SoundService() => _instance;

  /// Private internal constructor for singleton pattern
  SoundService._internal();

  // ===========================================================================
  // PRIVATE PROPERTIES
  // ===========================================================================

  /// AudioPlayer instance for sound effects playback
  final AudioPlayer _player = AudioPlayer();

  /// AudioPlayer instance for background music (separate for independent control)
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  /// Current volume level for sound effects (0.0 to 1.0)
  double _volume = SoundConstants.defaultVolume;

  /// Current volume level for background music (0.0 to 1.0)
  double _backgroundVolume = SoundConstants.backgroundVolume;

  /// Global toggle for enabling/disabling all sounds
  bool _soundsEnabled = true;

  /// Track if background music is currently playing
  bool _isBackgroundPlaying = false;

  // ===========================================================================
  // LOADING SOUNDS - App initialization and loading states
  // ===========================================================================

  /// Play sound when a loading process starts
  /// Use case: App startup, data fetching, file loading
  Future<void> playLoadingStart() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.loadingStart);
  }

  /// Play sound when a loading process completes successfully
  /// Use case: Loading finished, data ready, operation complete
  Future<void> playLoadingSuccess() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.loadingSuccess);
  }

  /// Play sound when revealing facts or educational content
  /// Use case: Tip reveal, fact display, educational insight
  Future<void> playFactReveal() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.factReveal);
  }

  // ===========================================================================
  // UI SOUNDS - User interface interactions
  // ===========================================================================

  /// Play sound for button presses and user taps
  /// Use case: Any button, icon, or tappable element
  Future<void> playButtonClick() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.buttonClick);
  }

  /// Play sound for screen transitions and navigation
  /// Use case: Page changes, modal openings, view transitions
  Future<void> playTransition() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.transition);
  }

  /// Play sound when changing learning strategies or modes
  /// Use case: Pace selection, difficulty change, mode switching
  Future<void> playStrategyChange() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.strategyChange);
  }

  // ===========================================================================
  // QUIZ SOUNDS - Learning and assessment feedback
  // ===========================================================================

  /// Play positive feedback sound for correct answers
  /// Use case: Quiz correct answer, successful completion
  Future<void> playCorrectAnswer() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.correctAnswer);
  }

  /// Play negative feedback sound for incorrect answers
  /// Use case: Quiz wrong answer, failed attempt
  Future<void> playWrongAnswer() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.wrongAnswer);
  }

  // ===========================================================================
  // BACKGROUND SOUNDS - Ambient audio for different app sections
  // ===========================================================================

  /// Play background music for authentication screens
  /// Use case: Login, signup, password reset screens
  Future<void> playAuthBackground() async {
    if (!_soundsEnabled) return;
    await _playBackgroundSound(SoundConstants.authBackground);
  }

  /// Play background music for home/main screens
  /// Use case: Dashboard, main menu, home navigation
  Future<void> playHomeBackground() async {
    if (!_soundsEnabled) return;
    await _playBackgroundSound(SoundConstants.homeBackground);
  }

  /// Stop background music
  /// Use case: When leaving screens with background audio
  Future<void> stopBackground() async {
    try {
      await _backgroundPlayer.stop();
      _isBackgroundPlaying = false;
    } catch (e) {
      debugPrint('Sound error stopping background: $e');
    }
  }

  /// Pause background music
  /// Use case: Temporary pause without resetting playback position
  Future<void> pauseBackground() async {
    try {
      await _backgroundPlayer.pause();
      _isBackgroundPlaying = false;
    } catch (e) {
      debugPrint('Sound error pausing background: $e');
    }
  }

  /// Resume background music
  /// Use case: Continue from where it was paused
  Future<void> resumeBackground() async {
    if (!_soundsEnabled) return;
    try {
      await _backgroundPlayer.resume();
      _isBackgroundPlaying = true;
    } catch (e) {
      debugPrint('Sound error resuming background: $e');
    }
  }

  // ===========================================================================
  // CORE AUDIO ENGINE
  // ===========================================================================

  /// Internal method to play a sound from asset path
  ///
  /// [assetPath] - Path to the sound file in assets folder
  ///
  /// Handles audio playback errors gracefully to prevent app crashes
  /// and provides debug logging for troubleshooting
  Future<void> _playSound(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Sound error playing $assetPath: $e');
    }
  }

  /// Internal method to play background music from asset path
  ///
  /// [assetPath] - Path to the background sound file in assets folder
  ///
  /// Sets background-specific volume and handles looping for ambient audio
  Future<void> _playBackgroundSound(String assetPath) async {
    try {
      await _backgroundPlayer.stop(); // Stop any currently playing background
      await _backgroundPlayer.play(AssetSource(assetPath));
      _isBackgroundPlaying = true;
    } catch (e) {
      debugPrint('Sound error playing background $assetPath: $e');
    }
  }

  // ===========================================================================
  // VOLUME CONTROL
  // ===========================================================================

  /// Set custom volume level for sound effects
  ///
  /// [volume] - Volume level between 0.0 (silent) and 1.0 (max)
  /// Automatically clamps values to valid range
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _player.setVolume(_volume);
  }

  /// Set custom volume level for background music
  ///
  /// [volume] - Volume level between 0.0 (silent) and 1.0 (max)
  /// Automatically clamps values to valid range
  void setBackgroundVolume(double volume) {
    _backgroundVolume = volume.clamp(0.0, 1.0);
    _backgroundPlayer.setVolume(_backgroundVolume);
  }

  /// Set volume to low preset (30%)
  /// Use case: Background sounds, subtle feedback
  void setLowVolume() {
    setVolume(SoundConstants.lowVolume);
  }

  /// Set volume to high preset (100%)
  /// Use case: Important notifications, critical feedback
  void setHighVolume() {
    setVolume(SoundConstants.highVolume);
  }

  /// Set background volume to preset level (20%)
  /// Use case: Ambient background music
  void setBackgroundVolumePreset() {
    setBackgroundVolume(SoundConstants.backgroundVolume);
  }

  // ===========================================================================
  // SOUND MANAGEMENT
  // ===========================================================================

  /// Enable or disable all sounds globally
  ///
  /// [enabled] - true to enable sounds, false to mute all audio
  /// Use case: User preferences, quiet mode, background app state
  void enableSounds(bool enabled) {
    _soundsEnabled = enabled;
    if (!enabled) {
      // Stop background music when sounds are disabled
      stopBackground();
    }
  }

  /// Check if sounds are currently enabled
  bool get areSoundsEnabled => _soundsEnabled;

  /// Check if background music is currently playing
  bool get isBackgroundPlaying => _isBackgroundPlaying;

  /// Get current sound effects volume level
  double get volume => _volume;

  /// Get current background music volume level
  double get backgroundVolume => _backgroundVolume;

  // ===========================================================================
  // RESOURCE MANAGEMENT
  // ===========================================================================

  /// Clean up audio resources when service is no longer needed
  ///
  /// Call this when the app is closing or when audio is no longer required
  /// to free up system resources
  void dispose() {
    _player.dispose();
    _backgroundPlayer.dispose();
  }
}