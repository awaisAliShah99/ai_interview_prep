
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ResumeService {
  Future<File?> pickAndSaveResume() async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.path == null) {
      return null;
    }

    final selectedFile = File(result.path!);

    final directory = await getApplicationDocumentsDirectory();

    final savedFile = await selectedFile.copy(
      '${directory.path}/resume.pdf',
    );

    return savedFile;
  }
}
