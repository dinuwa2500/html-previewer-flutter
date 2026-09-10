import 'package:flutter/material.dart';

class EditorToolbar extends StatelessWidget {
  final bool canUndo;
  final bool canRedo;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onFormat;
  final VoidCallback onToggleFindReplace;
  final bool isFindReplaceOpen;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onSelectAll;
  final VoidCallback onClear;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final double currentFontSize;

  const EditorToolbar({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
    required this.onFormat,
    required this.onToggleFindReplace,
    required this.isFindReplaceOpen,
    required this.onCopy,
    required this.onPaste,
    required this.onSelectAll,
    required this.onClear,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.currentFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131720) : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Undo & Redo
            IconButton(
              icon: const Icon(Icons.undo, size: 18),
              tooltip: 'Undo',
              onPressed: canUndo ? onUndo : null,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.redo, size: 18),
              tooltip: 'Redo',
              onPressed: canRedo ? onRedo : null,
              visualDensity: VisualDensity.compact,
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Format HTML
            OutlinedButton.icon(
              icon: const Icon(Icons.auto_fix_high, size: 15),
              label: const Text('Format', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                minimumSize: const Size(0, 30),
              ),
              onPressed: onFormat,
            ),
            const SizedBox(width: 6),

            // Find & Replace
            IconButton(
              icon: Icon(
                Icons.search,
                size: 18,
                color: isFindReplaceOpen ? theme.colorScheme.primary : null,
              ),
              tooltip: 'Find & Replace',
              onPressed: onToggleFindReplace,
              visualDensity: VisualDensity.compact,
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Copy & Paste
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy Code',
              onPressed: onCopy,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.paste, size: 18),
              tooltip: 'Paste',
              onPressed: onPaste,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.select_all, size: 18),
              tooltip: 'Select All',
              onPressed: onSelectAll,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.clear_all, size: 18),
              tooltip: 'Clear All',
              onPressed: onClear,
              visualDensity: VisualDensity.compact,
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Font Size adjustment
            IconButton(
              icon: const Icon(Icons.text_decrease, size: 18),
              tooltip: 'Decrease Font Size',
              onPressed: onZoomOut,
              visualDensity: VisualDensity.compact,
            ),
            Text(
              '${currentFontSize.toInt()}pt',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.text_increase, size: 18),
              tooltip: 'Increase Font Size',
              onPressed: onZoomIn,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
