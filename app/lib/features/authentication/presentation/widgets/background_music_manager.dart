import 'package:audioplayers/audioplayers.dart';
import '../../../../core/common/sound_constants.dart';

/// Singleton manager for Authentication Background Music.
///
/// This class is responsible for managing the ambient audio state during the
/// authentication flow (Login/Sign Up). It implements the Singleton design
/// pattern to ensure only one audio player instance exists, preventing audio
/// overlaps or restarts when navigating between authentication screens.
///
/// Dependencies:
/// - [SoundConstants]: Used for asset paths (`authBackground`) and volume configuration (`backgroundVolume`).
class BackgroundMusicManager {
  // ===========================================================================
  // SINGLETON PATTERN IMPLEMENTATION
  // ===========================================================================

  /// The single, static instance of the manager.
  static final BackgroundMusicManager _instance = BackgroundMusicManager._internal();

  /// Factory constructor returns the existing singleton instance.
  /// This allows `BackgroundMusicManager()` to be called multiple times while
  /// always returning the same object.
  factory BackgroundMusicManager() => _instance;

  /// Private internal constructor to prevent external instantiation.
  BackgroundMusicManager._internal();

  // ===========================================================================
  // PROPERTIES
  // ===========================================================================

  /// The dedicated [AudioPlayer] instance for background music.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Internal flag to track playback state and prevent redundant play calls.
  bool _isPlaying = false;

  // ===========================================================================
  // METHODS
  // ===========================================================================

  /// Starts the authentication background music if it is not already playing.
  ///
  /// This method is safe to call repeatedly (e.g., in `initState` of both Login
  /// and Signup pages). It checks [_isPlaying] to ensure the music continues
  /// seamlessly without restarting or glitching during navigation.
  ///
  /// Actions:
  /// 1. Checks if music is already active.
  /// 2. Sets the release mode to [ReleaseMode.loop] for continuous playback.
  /// 3. Sets the volume to [SoundConstants.backgroundVolume].
  /// 4. Plays the asset defined in [SoundConstants.authBackground].
  Future<void> playAuthMusic() async {
    // Prevent restart if the specific auth music is already running
    if (_isPlaying) return;

    try {
      // Configure player for indefinite looping suitable for ambient background
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // Apply the standardized background volume level (e.g., 0.2 or 0.3)
      await _audioPlayer.setVolume(SoundConstants.backgroundVolume);

      // Start playback using the specific authentication background asset
      await _audioPlayer.play(AssetSource(SoundConstants.authBackground));

      _isPlaying = true;
    } catch (e) {
      print("⚠️ Error playing auth music: $e");
      _isPlaying = false;
    }
  }

  /// Stops the music immediately and resets the internal state.
  ///
  /// This should be called when the user successfully authenticates and
  /// navigates away from the auth flow (e.g., to the Dashboard).
  Future<void> stopMusic() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        _isPlaying = false;
      }
    } catch (e) {
      print("Error stopping music: $e");
    }
  }
}