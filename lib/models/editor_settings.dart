import 'package:flutter/material.dart';

class EditorSettings {
  final ThemeMode themeMode;
  final double fontSize;
  final bool wordWrap;
  final bool autoSave;
  final bool showLineNumbers;
  final String defaultDevice; // 'mobile', 'tablet', 'desktop'
  final bool autoRunOnLoad;

  const EditorSettings({
    this.themeMode = ThemeMode.system,
    this.fontSize = 14.0,
    this.wordWrap = false,
    this.autoSave = true,
    this.showLineNumbers = true,
    this.defaultDevice = 'desktop',
    this.autoRunOnLoad = true,
  });

  EditorSettings copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    bool? wordWrap,
    bool? autoSave,
    bool? showLineNumbers,
    String? defaultDevice,
    bool? autoRunOnLoad,
  }) {
    return EditorSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      wordWrap: wordWrap ?? this.wordWrap,
      autoSave: autoSave ?? this.autoSave,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      defaultDevice: defaultDevice ?? this.defaultDevice,
      autoRunOnLoad: autoRunOnLoad ?? this.autoRunOnLoad,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'fontSize': fontSize,
      'wordWrap': wordWrap,
      'autoSave': autoSave,
      'showLineNumbers': showLineNumbers,
      'defaultDevice': defaultDevice,
      'autoRunOnLoad': autoRunOnLoad,
    };
  }

  factory EditorSettings.fromJson(Map<String, dynamic> json) {
    ThemeMode mode = ThemeMode.system;
    final modeName = json['themeMode'] as String?;
    if (modeName == 'dark') mode = ThemeMode.dark;
    if (modeName == 'light') mode = ThemeMode.light;

    return EditorSettings(
      themeMode: mode,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      wordWrap: json['wordWrap'] as bool? ?? false,
      autoSave: json['autoSave'] as bool? ?? true,
      showLineNumbers: json['showLineNumbers'] as bool? ?? true,
      defaultDevice: json['defaultDevice'] as String? ?? 'desktop',
      autoRunOnLoad: json['autoRunOnLoad'] as bool? ?? true,
    );
  }
}
