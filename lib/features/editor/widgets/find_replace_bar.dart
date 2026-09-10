import 'package:flutter/material.dart';

class FindReplaceBar extends StatelessWidget {
  final TextEditingController findController;
  final TextEditingController replaceController;
  final int currentMatchIndex;
  final int totalMatches;
  final VoidCallback onNextMatch;
  final VoidCallback onPreviousMatch;
  final VoidCallback onReplaceCurrent;
  final VoidCallback onReplaceAll;
  final VoidCallback onClose;
  final ValueChanged<String> onFindChanged;

  const FindReplaceBar({
    super.key,
    required this.findController,
    required this.replaceController,
    required this.currentMatchIndex,
    required this.totalMatches,
    required this.onNextMatch,
    required this.onPreviousMatch,
    required this.onReplaceCurrent,
    required this.onReplaceAll,
    required this.onClose,
    required this.onFindChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final matchInfo = totalMatches == 0
        ? (findController.text.isEmpty ? '' : 'No matches')
        : '${currentMatchIndex + 1} of $totalMatches';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2430) : const Color(0xFFF1F5F9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Find input & navigation
          Row(
            children: [
              const Icon(Icons.search, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: findController,
                    onChanged: onFindChanged,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Find...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: findController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                findController.clear();
                                onFindChanged('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                matchInfo,
                style: TextStyle(
                  fontSize: 12,
                  color: totalMatches > 0 ? Colors.amber : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                tooltip: 'Previous match',
                onPressed: totalMatches > 0 ? onPreviousMatch : null,
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                tooltip: 'Next match',
                onPressed: totalMatches > 0 ? onNextMatch : null,
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'Close search',
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Row 2: Replace input & replace actions
          Row(
            children: [
              const Icon(Icons.find_replace, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: replaceController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Replace with...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(64, 34),
                ),
                onPressed: totalMatches > 0 ? onReplaceCurrent : null,
                child: const Text('Replace', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(76, 34),
                ),
                onPressed: totalMatches > 0 ? onReplaceAll : null,
                child: const Text('Replace All', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
