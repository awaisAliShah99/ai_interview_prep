
import 'package:audioplayers/audioplayers.dart';

class AudioPlaybackService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playRecording(String filePath) async {
    await _player.play(
      DeviceFileSource(filePath),
    );
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
