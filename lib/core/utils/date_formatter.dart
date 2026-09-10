class DateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24 && now.day == date.day) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return 'Today $h:$m';
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      if (yesterday.year == date.year &&
          yesterday.month == date.month &&
          yesterday.day == date.day) {
        final h = date.hour.toString().padLeft(2, '0');
        final m = date.minute.toString().padLeft(2, '0');
        return 'Yesterday $h:$m';
      } else if (now.year == date.year) {
        return '${_months[date.month - 1]} ${date.day}';
      } else {
        return '${_months[date.month - 1]} ${date.day}, ${date.year}';
      }
    }
  }
}
