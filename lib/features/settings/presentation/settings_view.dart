import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../history/presentation/history_controller.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settings = context.watch<SettingsController>();
    final history = context.read<HistoryController>();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        children: [
          // Section: Appearance
          _buildSectionHeader('Appearance', Icons.palette_outlined),
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF131722) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: const Text('Choose between light, dark, or system default'),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 16)),
                      ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 16)),
                      ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.settings_suggest, size: 16)),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (modes) {
                      if (modes.isNotEmpty) settings.updateThemeMode(modes.first);
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Code Editor
          _buildSectionHeader('Editor', Icons.code_outlined),
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF131722) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Font Size'),
                  subtitle: Text('${settings.fontSize.toInt()} pt'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        onPressed: () => settings.updateFontSize(settings.fontSize - 1),
                      ),
                      Slider(
                        value: settings.fontSize,
                        min: 11,
                        max: 26,
                        divisions: 15,
                        label: '${settings.fontSize.toInt()}pt',
                        onChanged: settings.updateFontSize,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        onPressed: () => settings.updateFontSize(settings.fontSize + 1),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Word Wrap'),
                  subtitle: const Text('Wrap long lines of HTML code horizontally'),
                  value: settings.wordWrap,
                  onChanged: settings.toggleWordWrap,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Line Numbers'),
                  subtitle: const Text('Show line gutter along the left side of the editor'),
                  value: settings.showLineNumbers,
                  onChanged: settings.toggleShowLineNumbers,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Auto-Save'),
                  subtitle: const Text('Automatically save code changes to local storage'),
                  value: settings.autoSave,
                  onChanged: settings.toggleAutoSave,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Preview
          _buildSectionHeader('Preview & Renderer', Icons.preview_outlined),
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF131722) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Default Viewport'),
                  subtitle: const Text('Default simulated device frame'),
                  trailing: DropdownButton<String>(
                    value: settings.defaultDevice,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'desktop', child: Text('Desktop (100%)')),
                      DropdownMenuItem(value: 'tablet', child: Text('Tablet (768px)')),
                      DropdownMenuItem(value: 'mobile', child: Text('Mobile (375px)')),
                    ],
                    onChanged: (val) {
                      if (val != null) settings.updateDefaultDevice(val);
                    },
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Auto-Run on Load'),
                  subtitle: const Text('Render preview automatically when a template or file opens'),
                  value: settings.autoRunOnLoad,
                  onChanged: settings.toggleAutoRunOnLoad,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Data & Storage
          _buildSectionHeader('Storage & Reset', Icons.storage_outlined),
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF131722) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Clear All Project History'),
                  subtitle: const Text('Deletes all saved project items from local storage'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear All History?'),
                        content: const Text('This will delete all saved projects. This cannot be undone.'),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('History cleared!')),
                              );
                            },
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Center(
            child: Column(
              children: [
                const Text(
                  'Online HTML Viewer / HTML Previewer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.0.0 • Production Ready Flutter App',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  'Built with Flutter, Material 3 & WebView',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[600] : Colors.grey[500]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF6366F1),
            ),
          ),
        ],
      ),
    );
  }
}
