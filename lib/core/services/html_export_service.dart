import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HtmlExportService {
  /// Copy HTML code to system clipboard
  static Future<void> copyToClipboard(String html) async {
    await Clipboard.setData(ClipboardData(text: html));
  }

  /// Import an HTML/HTM/TXT file and return its content
  static Future<String?> importHtmlFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['html', 'htm', 'txt'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;

      // Web or in-memory bytes
      if (file.bytes != null) {
        return utf8.decode(file.bytes!);
      }

      // Local file system
      if (!kIsWeb && file.path != null) {
        final ioFile = File(file.path!);
        return await ioFile.readAsString();
      }

      return null;
    } catch (e) {
      debugPrint('Error importing file: $e');
      rethrow;
    }
  }

  /// Export HTML code to a file as index.html
  static Future<String?> exportHtmlFile(String html) async {
    try {
      final outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save HTML File',
        fileName: 'index.html',
        type: FileType.custom,
        allowedExtensions: ['html'],
        bytes: kIsWeb ? Uint8List.fromList(utf8.encode(html)) : null,
      );

      if (outputFile == null) return null;

      if (!kIsWeb) {
        final file = File(outputFile);
        await file.writeAsString(html);
      }

      return outputFile;
    } catch (e) {
      debugPrint('Error exporting file: $e');
      rethrow;
    }
  }
}
