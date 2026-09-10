import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/services/html_beautifier.dart';
import 'package:app/core/utils/date_formatter.dart';
import 'package:app/models/editor_settings.dart';
import 'package:app/models/history_item.dart';
import 'package:app/models/html_template.dart';

void main() {
  group('HtmlBeautifier Tests', () {
    test('formats nested HTML tags with 2-space indentation', () {
      const rawHtml = '<div><h1>Title</h1><p>Paragraph</p></div>';
      final formatted = HtmlBeautifier.format(rawHtml);
      expect(formatted.contains('<div>'), isTrue);
      expect(formatted.contains('  <h1>'), isTrue);
      expect(formatted.contains('    Title'), isTrue);
      expect(formatted.contains('  </h1>'), isTrue);
    });

    test('handles empty HTML gracefully', () {
      expect(HtmlBeautifier.format(''), equals(''));
    });
  });

  group('HtmlTemplate Tests', () {
    test('contains 8 pre-built templates', () {
      expect(HtmlTemplate.templates.length, equals(8));
      final ids = HtmlTemplate.templates.map((t) => t.id).toSet();
      expect(ids.contains('basic'), isTrue);
      expect(ids.contains('login'), isTrue);
      expect(ids.contains('portfolio'), isTrue);
      expect(ids.contains('landing'), isTrue);
      expect(ids.contains('card'), isTrue);
      expect(ids.contains('calculator'), isTrue);
      expect(ids.contains('jsdemo'), isTrue);
      expect(ids.contains('cssanimation'), isTrue);
    });

    test('defaultHtml contains essential DOCTYPE and elements', () {
      expect(HtmlTemplate.defaultHtml.contains('<!DOCTYPE html>'), isTrue);
      expect(HtmlTemplate.defaultHtml.contains('Hello World'), isTrue);
      expect(HtmlTemplate.defaultHtml.contains('<button'), isTrue);
    });
  });

  group('HistoryItem Tests', () {
    test('serializes and deserializes correctly', () {
      final now = DateTime.now();
      final item = HistoryItem(
        id: 'test-1',
        title: 'Test Project',
        code: '<h1>Test</h1>',
        createdAt: now,
        updatedAt: now,
      );

      final json = item.toJson();
      final restored = HistoryItem.fromJson(json);

      expect(restored.id, equals('test-1'));
      expect(restored.title, equals('Test Project'));
      expect(restored.code, equals('<h1>Test</h1>'));
      expect(restored.formattedSize, equals('${restored.sizeInBytes} B'));
    });
  });

  group('EditorSettings Tests', () {
    test('serializes and deserializes default settings', () {
      const settings = EditorSettings(
        fontSize: 16.0,
        wordWrap: true,
        themeMode: ThemeMode.dark,
      );

      final json = settings.toJson();
      final restored = EditorSettings.fromJson(json);

      expect(restored.fontSize, equals(16.0));
      expect(restored.wordWrap, isTrue);
      expect(restored.themeMode, equals(ThemeMode.dark));
    });
  });

  group('DateFormatter Tests', () {
    test('formats relative dates accurately', () {
      final now = DateTime.now();
      expect(DateFormatter.formatRelative(now), equals('Just now'));

      final pastMinute = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.formatRelative(pastMinute), equals('5m ago'));
    });
  });
}
