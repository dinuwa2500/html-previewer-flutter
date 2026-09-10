import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/editor_settings.dart';
import '../../models/history_item.dart';
import '../../models/html_template.dart';

class StorageService {
  static const String _keyCurrentHtml = 'html_viewer_current_code';
  static const String _keyHistory = 'html_viewer_history_list';
  static const String _keySettings = 'html_viewer_settings';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Current HTML Code ---
  Future<void> saveCurrentHtml(String code) async {
    await _prefs.setString(_keyCurrentHtml, code);
  }

  String getCurrentHtml() {
    return _prefs.getString(_keyCurrentHtml) ?? HtmlTemplate.defaultHtml;
  }

  // --- History Items ---
  Future<void> saveHistory(List<HistoryItem> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyHistory, jsonEncode(jsonList));
  }

  List<HistoryItem> getHistory() {
    final raw = _prefs.getString(_keyHistory);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_keyHistory);
  }

  // --- Settings ---
  Future<void> saveSettings(EditorSettings settings) async {
    await _prefs.setString(_keySettings, jsonEncode(settings.toJson()));
  }

  EditorSettings getSettings() {
    final raw = _prefs.getString(_keySettings);
    if (raw == null || raw.isEmpty) return const EditorSettings();
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return EditorSettings.fromJson(decoded);
    } catch (_) {
      return const EditorSettings();
    }
  }
}
