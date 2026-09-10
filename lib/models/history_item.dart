import 'dart:convert';

class HistoryItem {
  final String id;
  final String title;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sizeInBytes;

  HistoryItem({
    required this.id,
    required this.title,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    int? sizeInBytes,
  }) : sizeInBytes = sizeInBytes ?? utf8.encode(code).length;

  HistoryItem copyWith({
    String? id,
    String? title,
    String? code,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final updatedCode = code ?? this.code;
    return HistoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      code: updatedCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sizeInBytes: utf8.encode(updatedCode).length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sizeInBytes': sizeInBytes,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      code: json['code'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      sizeInBytes: json['sizeInBytes'] as int?,
    );
  }

  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
