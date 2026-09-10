import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/html_export_service.dart';
import '../features/editor/presentation/editor_controller.dart';
import '../features/editor/presentation/editor_view.dart';
import '../features/history/presentation/history_view.dart';
import '../features/preview/presentation/preview_controller.dart';
import '../features/preview/presentation/preview_view.dart';
import '../features/settings/presentation/settings_controller.dart';
import '../features/settings/presentation/settings_view.dart';
import '../features/templates/presentation/templates_view.dart';
import 'theme.dart';

class HtmlViewerApp extends StatelessWidget {
  const HtmlViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return MaterialApp(
      title: 'HTML Viewer & Previewer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedNavigationIndex = 0; // 0: Editor/Preview, 1: Templates, 2: History, 3: Settings
  int _mobileTabIndex = 0; // 0: Editor, 1: Preview

  void _runCode() {
    final editor = context.read<EditorController>();
    final preview = context.read<PreviewController>();

    preview.runHtml(editor.code);

    // If on mobile, switch to Preview tab automatically
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    if (!isDesktop) {
      setState(() {
        _mobileTabIndex = 1;
        _selectedNavigationIndex = 0;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rendering HTML in Preview! 🚀'),
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleImport() async {
    try {
      final code = await HtmlExportService.importHtmlFile();
      if (code != null && mounted) {
        final editor = context.read<EditorController>();
        final preview = context.read<PreviewController>();
        editor.loadCode(code, title: 'imported.html');
        preview.runHtml(code);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File imported successfully! 📄'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import file: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleExport() async {
    final editor = context.read<EditorController>();
    try {
      final path = await HtmlExportService.exportHtmlFile(editor.code);
      if (path != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported to $path 💾'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.html, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'HTML Viewer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          // Run Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _runCode,
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text(
              'Run',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),

          // Menu Popup for Import / Export / Copy
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onSelected: (val) {
              if (val == 'import') _handleImport();
              if (val == 'export') _handleExport();
              if (val == 'copy') {
                final editor = context.read<EditorController>();
                editor.copyAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('HTML copied to clipboard! 📋'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.file_open_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Import HTML File (.html, .txt)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Export as index.html'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Copy HTML Code'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark),
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(isDark),
    );
  }

  // Desktop / Tablet layout with Navigation Rail and Split Screen
  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      children: [
        // Navigation Rail
        NavigationRail(
          selectedIndex: _selectedNavigationIndex,
          onDestinationSelected: (idx) {
            setState(() => _selectedNavigationIndex = idx);
          },
          labelType: NavigationRailLabelType.all,
          backgroundColor: isDark ? const Color(0xFF0F141C) : const Color(0xFFF1F5F9),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.code_outlined),
              selectedIcon: Icon(Icons.code),
              label: Text('Editor'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_customize_outlined),
              selectedIcon: Icon(Icons.dashboard_customize),
              label: Text('Templates'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: Text('History'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),

        // Main Content Area
        Expanded(
          child: IndexedStack(
            index: _selectedNavigationIndex,
            children: [
              // 0: Split Screen: Editor on Left, Preview on Right
              _buildDesktopSplitView(isDark),
              // 1: Templates View
              TemplatesView(
                onSelectTemplate: () {
                  setState(() => _selectedNavigationIndex = 0);
                },
              ),
              // 2: History View
              HistoryView(
                onOpenProject: () {
                  setState(() => _selectedNavigationIndex = 0);
                },
              ),
              // 3: Settings View
              const SettingsView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopSplitView(bool isDark) {
    return Row(
      children: [
        // Left Half: HTML Editor
        const Expanded(
          flex: 5,
          child: EditorView(),
        ),
        // Divider
        VerticalDivider(
          width: 1,
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
        ),
        // Right Half: Previewer
        const Expanded(
          flex: 5,
          child: PreviewView(),
        ),
      ],
    );
  }

  // Mobile layout with Tab switching
  Widget _buildMobileLayout(bool isDark) {
    if (_selectedNavigationIndex == 1) {
      return TemplatesView(
        onSelectTemplate: () {
          setState(() {
            _selectedNavigationIndex = 0;
            _mobileTabIndex = 0;
          });
        },
      );
    }
    if (_selectedNavigationIndex == 2) {
      return HistoryView(
        onOpenProject: () {
          setState(() {
            _selectedNavigationIndex = 0;
            _mobileTabIndex = 0;
          });
        },
      );
    }
    if (_selectedNavigationIndex == 3) {
      return const SettingsView();
    }

    // Editor & Preview Tab Mode
    return Column(
      children: [
        // Segmented Tab Switcher (HTML vs Preview)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: isDark ? const Color(0xFF0F141C) : const Color(0xFFF1F5F9),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(
                  value: 0,
                  icon: Icon(Icons.code, size: 16),
                  label: Text('HTML Code'),
                ),
                ButtonSegment<int>(
                  value: 1,
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('Preview'),
                ),
              ],
              selected: {_mobileTabIndex},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  setState(() => _mobileTabIndex = set.first);
                }
              },
            ),
          ),
        ),
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _mobileTabIndex,
            children: const [
              EditorView(),
              PreviewView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBottomNav(bool isDark) {
    return NavigationBar(
      selectedIndex: _selectedNavigationIndex,
      onDestinationSelected: (idx) {
        setState(() => _selectedNavigationIndex = idx);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.code_outlined),
          selectedIcon: Icon(Icons.code),
          label: 'Editor',
        ),
        NavigationDestination(
          icon: Icon(Icons.dashboard_customize_outlined),
          selectedIcon: Icon(Icons.dashboard_customize),
          label: 'Templates',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
