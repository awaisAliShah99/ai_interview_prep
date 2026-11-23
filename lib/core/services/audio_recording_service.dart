
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecordingService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> startRecording() async {
    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      return false;
    }

    final directory = await getApplicationDocumentsDirectory();

    final filePath =
        '${directory.path}/interview_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
      ),
      path: filePath,
    );

    return true;
  }

  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
