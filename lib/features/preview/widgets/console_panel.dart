import 'package:flutter/material.dart';
import '../../../models/console_log.dart';

class ConsolePanel extends StatefulWidget {
  final List<ConsoleLog> logs;
  final VoidCallback onClear;
  final VoidCallback onClose;

  const ConsolePanel({
    super.key,
    required this.logs,
    required this.onClear,
    required this.onClose,
  });

  @override
  State<ConsolePanel> createState() => _ConsolePanelState();
}

class _ConsolePanelState extends State<ConsolePanel> {
  String _selectedFilter = 'all'; // 'all', 'error', 'warn', 'info'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredLogs = widget.logs.where((l) {
      if (_selectedFilter == 'error') return l.level == ConsoleLogLevel.error;
      if (_selectedFilter == 'warn') return l.level == ConsoleLogLevel.warn;
      if (_selectedFilter == 'info') return l.level == ConsoleLogLevel.info;
      return true;
    }).toList();

    final errorCount =
        widget.logs.where((l) => l.level == ConsoleLogLevel.error).length;
    final warnCount =
        widget.logs.where((l) => l.level == ConsoleLogLevel.warn).length;
    final infoCount =
        widget.logs.where((l) => l.level == ConsoleLogLevel.info).length;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F141C) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: isDark ? const Color(0xFF181F2C) : const Color(0xFFE2E8F0),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'JavaScript Console',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Spacer(),

                // Filter tabs
                _buildFilterChip('all', 'All (${widget.logs.length})'),
                const SizedBox(width: 4),
                _buildFilterChip('error', '❌ $errorCount', isError: true),
                const SizedBox(width: 4),
                _buildFilterChip('warn', '⚠️ $warnCount', isWarn: true),
                const SizedBox(width: 4),
                _buildFilterChip('info', 'ℹ️ $infoCount'),
                const VerticalDivider(width: 16, indent: 6, endIndent: 6),

                // Clear button
                IconButton(
                  icon: const Icon(Icons.block, size: 16),
                  tooltip: 'Clear Console',
                  onPressed: widget.onClear,
                  visualDensity: VisualDensity.compact,
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  tooltip: 'Close Console',
                  onPressed: widget.onClose,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Logs List
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      'No console output yet.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredLogs.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    ),
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return _buildLogItem(log, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String filter,
    String label, {
    bool isError = false,
    bool isWarn = false,
  }) {
    final isSelected = _selectedFilter == filter;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = filter),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? (isError
                  ? Colors.red.withAlpha(60)
                  : (isWarn
                      ? Colors.amber.withAlpha(60)
                      : Theme.of(context).colorScheme.primary.withAlpha(50)))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isError
                ? Colors.redAccent
                : (isWarn ? Colors.amber[700] : null),
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(ConsoleLog log, bool isDark) {
    Color textColor;
    IconData icon;
    Color iconColor;

    switch (log.level) {
      case ConsoleLogLevel.error:
        textColor = const Color(0xFFEF4444);
        icon = Icons.cancel;
        iconColor = Colors.redAccent;
        break;
      case ConsoleLogLevel.warn:
        textColor = const Color(0xFFF59E0B);
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.amber;
        break;
      case ConsoleLogLevel.info:
        textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
        icon = Icons.info_outline;
        iconColor = const Color(0xFF38BDF8);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            log.timeFormatted,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              log.message,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                color: textColor,
                fontWeight: log.level == ConsoleLogLevel.error
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
