import 'package:audioplayers/audioplayers.dart';

class MusicServices {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Duration _duration = Duration.zero;
  final Duration _position = Duration.zero;
  Duration? get duration => _duration;
  Duration get position => _position;
  Function()? onComplete;

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration> get durationStream => _audioPlayer.onDurationChanged;
  //

  Future<Duration?> getDuration(String path) async {
    await _audioPlayer.setSource(DeviceFileSource(path));
    return await _audioPlayer.getDuration();
  }

  Future<void> play(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));

    _audioPlayer.onPlayerComplete.listen((event) {
      if (onComplete != null) {
        onComplete!();
      }
    });
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
