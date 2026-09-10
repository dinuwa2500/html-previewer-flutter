import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/history_item.dart';
import '../../editor/presentation/editor_controller.dart';
import '../../preview/presentation/preview_controller.dart';
import 'history_controller.dart';

class HistoryView extends StatelessWidget {
  final VoidCallback onOpenProject;

  const HistoryView({super.key, required this.onOpenProject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final history = context.watch<HistoryController>();
    final editor = context.watch<EditorController>();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Recent Projects'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Save Current As Project Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: () => _showSaveProjectDialog(context, editor, history),
            icon: const Icon(Icons.bookmark_add_outlined, size: 16),
            label: const Text('Save Current', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),

          // Clear History action
          if (history.totalCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear All History',
              onPressed: () => _confirmClearHistory(context, history),
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: TextField(
              onChanged: history.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search saved projects...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                fillColor: isDark ? const Color(0xFF131722) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            ),
          ),

          // History List
          Expanded(
            child: history.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 48, color: Colors.grey[500]),
                        const SizedBox(height: 12),
                        Text(
                          history.searchQuery.isEmpty
                              ? 'No saved projects yet.'
                              : 'No matching projects found.',
                          style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: history.items.length,
                    itemBuilder: (context, index) {
                      final item = history.items[index];
                      return _buildHistoryCard(context, item, isDark, history);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    HistoryItem item,
    bool isDark,
    HistoryController history,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      color: isDark ? const Color(0xFF131722) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.html_outlined, color: Color(0xFF6366F1)),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text(
                DateFormatter.formatRelative(item.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '• ${item.formattedSize}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new, size: 18),
              tooltip: 'Open in Editor',
              onPressed: () => _openItem(context, item),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: 'Delete',
              onPressed: () => history.deleteProject(item.id),
            ),
          ],
        ),
        onTap: () => _openItem(context, item),
      ),
    );
  }

  void _openItem(BuildContext context, HistoryItem item) {
    final editor = context.read<EditorController>();
    final preview = context.read<PreviewController>();

    editor.loadCode(item.code, title: item.title);
    preview.runHtml(item.code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opened "${item.title}"!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    onOpenProject();
  }

  void _showSaveProjectDialog(
    BuildContext context,
    EditorController editor,
    HistoryController history,
  ) {
    final titleController = TextEditingController(text: editor.currentTitle);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Project to History'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Project Name',
            hintText: 'e.g. Portfolio v2',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                history.saveProject(title, editor.code);
                editor.setTitle(title);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved project "$title" to History! 📁'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context, HistoryController history) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This will remove all saved projects from history. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              history.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
