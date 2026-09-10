import 'dart:convert';
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
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['html', 'htm', 'txt'],
      );

      if (files.isEmpty) return null;

      final file = files.first;
      final bytes = await file.readAsBytes();
      return utf8.decode(bytes);
    } catch (e) {
      debugPrint('Error importing file: $e');
      rethrow;
    }
  }

  /// Export HTML code to a file as index.html
  static Future<String?> exportHtmlFile(String html) async {
    try {
      final bytes = Uint8List.fromList(utf8.encode(html));
      final outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save HTML File',
        fileName: 'index.html',
        type: FileType.custom,
        allowedExtensions: ['html'],
        bytes: bytes,
      );

      if (outputFile == null) return null;

      try {
        return outputFile.toFilePath();
      } catch (_) {
        return outputFile.path.isNotEmpty ? outputFile.path : outputFile.toString();
      }
    } catch (e) {
      debugPrint('Error exporting file: $e');
      rethrow;
    }
  }
}
