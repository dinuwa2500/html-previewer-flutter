enum ConsoleLogLevel {
  info,
  warn,
  error,
}

class ConsoleLog {
  final String id;
  final ConsoleLogLevel level;
  final String message;
  final DateTime timestamp;
  final String? source;

  const ConsoleLog({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
    this.source,
  });

  String get timeFormatted {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    final ms = (timestamp.millisecond % 1000).toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }
}
