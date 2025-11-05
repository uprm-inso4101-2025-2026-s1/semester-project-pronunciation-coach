
import 'package:audioplayers/audioplayers.dart';
import 'sound_constants.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  double _volume = SoundConstants.defaultVolume;
  bool _soundsEnabled = true;

  // Loading sounds
  Future<void> playLoadingStart() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.loadingStart);
  }

  Future<void> playLoadingSuccess() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.loadingSuccess);
  }

  Future<void> playStrategyChange() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.strategyChange);
  }

  Future<void> playFactReveal() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.factReveal);
  }

  // UI sounds
  Future<void> playButtonClick() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.buttonClick);
  }

  Future<void> playTransition() async {
    if (!_soundsEnabled) return;
    await _playSound(SoundConstants.transition);
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print('Sound error: $e');
    }
  }

  // Volume control
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _player.setVolume(_volume);
  }

  void setLowVolume() {
    setVolume(SoundConstants.lowVolume);
  }

  void setHighVolume() {
    setVolume(SoundConstants.highVolume);
  }

  void enableSounds(bool enabled) {
    _soundsEnabled = enabled;
  }

  bool get areSoundsEnabled => _soundsEnabled;
  double get volume => _volume;

  void dispose() {
    _player.dispose();
  }


}


