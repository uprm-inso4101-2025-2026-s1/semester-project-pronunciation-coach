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

  /// AudioPlayer instance for sound playback
  final AudioPlayer _player = AudioPlayer();

  /// Current volume level (0.0 to 1.0)
  double _volume = SoundConstants.defaultVolume;

  /// Global toggle for enabling/disabling all sounds
  bool _soundsEnabled = true;

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

  // ===========================================================================
  // VOLUME CONTROL
  // ===========================================================================

  /// Set custom volume level
  ///
  /// [volume] - Volume level between 0.0 (silent) and 1.0 (max)
  /// Automatically clamps values to valid range
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _player.setVolume(_volume);
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

  // ===========================================================================
  // SOUND MANAGEMENT
  // ===========================================================================

  /// Enable or disable all sounds globally
  ///
  /// [enabled] - true to enable sounds, false to mute all audio
  /// Use case: User preferences, quiet mode, background app state
  void enableSounds(bool enabled) {
    _soundsEnabled = enabled;
  }

  /// Check if sounds are currently enabled
  bool get areSoundsEnabled => _soundsEnabled;

  /// Get current volume level
  double get volume => _volume;

  // ===========================================================================
  // RESOURCE MANAGEMENT
  // ===========================================================================

  /// Clean up audio resources when service is no longer needed
  ///
  /// Call this when the app is closing or when audio is no longer required
  /// to free up system resources
  void dispose() {
    _player.dispose();
  }
}
