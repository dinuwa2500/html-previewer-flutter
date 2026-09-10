import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../settings/presentation/settings_controller.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/find_replace_bar.dart';
import '../widgets/line_number_gutter.dart';
import 'editor_controller.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final editor = context.watch<EditorController>();
    final settings = context.watch<SettingsController>();

    // Update syntax controller theme mode
    editor.textController.isDarkMode = isDark;

    final fontSize = settings.fontSize;
    const lineHeight = 1.5;

    return Column(
      children: [
        // Top Toolbar
        EditorToolbar(
          canUndo: editor.canUndo,
          canRedo: editor.canRedo,
          onUndo: editor.undo,
          onRedo: editor.redo,
          onFormat: editor.formatHtml,
          onToggleFindReplace: editor.toggleFindReplace,
          isFindReplaceOpen: editor.isFindReplaceOpen,
          onCopy: () {
            editor.copyAll();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('HTML copied to clipboard! 📋'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onPaste: editor.pasteFromClipboard,
          onSelectAll: editor.selectAll,
          onClear: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Clear Editor?'),
                content: const Text('Are you sure you want to clear all HTML code? You can undo this action.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      editor.clearCode();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            );
          },
          onZoomIn: () => settings.updateFontSize(fontSize + 1),
          onZoomOut: () => settings.updateFontSize(fontSize - 1),
          currentFontSize: fontSize,
        ),

        // Optional Find & Replace Bar
        if (editor.isFindReplaceOpen)
          FindReplaceBar(
            findController: editor.findController,
            replaceController: editor.replaceController,
            currentMatchIndex: editor.currentMatchIndex,
            totalMatches: editor.totalMatches,
            onNextMatch: editor.nextMatch,
            onPreviousMatch: editor.previousMatch,
            onReplaceCurrent: editor.replaceCurrent,
            onReplaceAll: editor.replaceAll,
            onClose: editor.toggleFindReplace,
            onFindChanged: editor.onFindChanged,
          ),

        // Editor Body (Gutter + Code TextField)
        Expanded(
          child: Container(
            color: isDark ? const Color(0xFF0F141C) : const Color(0xFFFFFFFF),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Line Number Gutter
                if (settings.showLineNumbers)
                  LineNumberGutter(
                    lineCount: editor.lineCount,
                    scrollController: editor.gutterScrollController,
                    fontSize: fontSize,
                    lineHeight: lineHeight,
                    isDarkMode: isDark,
                  ),

                // Main Text Input Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
                    child: settings.wordWrap
                        ? _buildTextField(editor, fontSize, lineHeight, isDark)
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 2400, // Wide viewport for un-wrapped lines
                              child: _buildTextField(editor, fontSize, lineHeight, isDark),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Status Bar
        Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131720) : const Color(0xFFF1F5F9),
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                editor.currentTitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const Spacer(),
              Text(
                'Lines: ${editor.lineCount}  |  Chars: ${editor.charCount}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    editor.isDirty ? Icons.circle : Icons.check_circle,
                    size: 10,
                    color: editor.isDirty ? Colors.amber : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    editor.isDirty ? 'Unsaved' : 'Saved',
                    style: TextStyle(
                      fontSize: 11,
                      color: editor.isDirty ? Colors.amber : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    EditorController editor,
    double fontSize,
    double lineHeight,
    bool isDark,
  ) {
    return TextField(
      controller: editor.textController,
      scrollController: editor.editorScrollController,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      enableSuggestions: false,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: fontSize,
        height: lineHeight,
        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      cursorColor: const Color(0xFF6366F1),
    );
  }
}
