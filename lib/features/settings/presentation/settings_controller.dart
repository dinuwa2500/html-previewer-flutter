import 'package:flutter/material.dart';
import '../../../core/storage/storage_service.dart';
import '../../../models/editor_settings.dart';

class SettingsController extends ChangeNotifier {
  final StorageService _storage;
  late EditorSettings _settings;

  SettingsController(this._storage) {
    _settings = _storage.getSettings();
  }

  EditorSettings get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  double get fontSize => _settings.fontSize;
  bool get wordWrap => _settings.wordWrap;
  bool get autoSave => _settings.autoSave;
  bool get showLineNumbers => _settings.showLineNumbers;
  String get defaultDevice => _settings.defaultDevice;
  bool get autoRunOnLoad => _settings.autoRunOnLoad;

  Future<void> updateThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateFontSize(double size) async {
    final clamped = size.clamp(11.0, 28.0);
    _settings = _settings.copyWith(fontSize: clamped);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleWordWrap(bool value) async {
    _settings = _settings.copyWith(wordWrap: value);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleAutoSave(bool value) async {
    _settings = _settings.copyWith(autoSave: value);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleShowLineNumbers(bool value) async {
    _settings = _settings.copyWith(showLineNumbers: value);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateDefaultDevice(String device) async {
    _settings = _settings.copyWith(defaultDevice: device);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleAutoRunOnLoad(bool value) async {
    _settings = _settings.copyWith(autoRunOnLoad: value);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }
}
