import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/html_template.dart';
import '../../editor/presentation/editor_controller.dart';
import '../../preview/presentation/preview_controller.dart';

class TemplatesView extends StatefulWidget {
  final VoidCallback onSelectTemplate;

  const TemplatesView({super.key, required this.onSelectTemplate});

  @override
  State<TemplatesView> createState() => _TemplatesViewState();
}

class _TemplatesViewState extends State<TemplatesView> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Starter',
    'UI Components',
    'Websites',
    'Apps',
    'Interactive',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredTemplates = HtmlTemplate.templates.where((t) {
      if (_selectedCategory == 'All') return true;
      return t.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.dashboard_customize_outlined,
                          color: Color(0xFF6366F1),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HTML Templates',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Select a modern template to inspect, edit, and render',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _selectedCategory = category);
                            },
                            showCheckmark: false,
                            selectedColor: const Color(0xFF6366F1),
                            labelStyle: TextStyle(
                              fontSize: 12.5,
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Template Cards Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 380,
                mainAxisExtent: 220,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final template = filteredTemplates[index];
                  return _buildTemplateCard(template, isDark);
                },
                childCount: filteredTemplates.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(HtmlTemplate template, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      color: isDark ? const Color(0xFF131722) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(template.icon, size: 20, color: const Color(0xFF818CF8)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    template.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    template.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                template.description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                    onPressed: () => _applyTemplate(template),
                    icon: const Icon(Icons.bolt, size: 16),
                    label: const Text('Load to Editor', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyTemplate(HtmlTemplate template) {
    final editor = context.read<EditorController>();
    final preview = context.read<PreviewController>();

    editor.loadCode(template.code, title: '${template.id}.html');
    preview.runHtml(template.code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded "${template.title}" into editor! ✨'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    widget.onSelectTemplate();
  }
}
