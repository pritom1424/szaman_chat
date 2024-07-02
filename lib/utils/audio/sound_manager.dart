import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  SoundManager._privateConstructor();
  static final SoundManager _instance = SoundManager._privateConstructor();
  factory SoundManager() {
    return _instance;
  }
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static bool isPush = false;
  Future<void> playSound(String path) async {
    if (!_isPlaying) {
      try {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource(path));
        print("did Sound");
        _isPlaying = true;
      } catch (e) {
        print("did Sound error: $e");
      }
    }
  }

  Future<void> stopSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      print("did Sound off");
      _isPlaying = false;
    }
  }

  bool get isPlaying {
    return _isPlaying;
  }
}
