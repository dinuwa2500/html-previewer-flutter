import 'package:flutter/material.dart';

class PreviewToolbar extends StatelessWidget {
  final String currentDevice;
  final ValueChanged<String> onDeviceChanged;
  final double currentZoom;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetZoom;
  final VoidCallback onRefresh;
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;
  final VoidCallback onToggleConsole;
  final bool isConsoleOpen;
  final int errorCount;

  const PreviewToolbar({
    super.key,
    required this.currentDevice,
    required this.onDeviceChanged,
    required this.currentZoom,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetZoom,
    required this.onRefresh,
    required this.onToggleFullscreen,
    required this.isFullscreen,
    required this.onToggleConsole,
    required this.isConsoleOpen,
    required this.errorCount,
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
            // Refresh Button
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              tooltip: 'Refresh Preview (↻)',
              onPressed: onRefresh,
              visualDensity: VisualDensity.compact,
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Device Switcher Segmented Control
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'mobile',
                  icon: Icon(Icons.phone_android, size: 15),
                  tooltip: 'Mobile View (375px)',
                ),
                ButtonSegment<String>(
                  value: 'tablet',
                  icon: Icon(Icons.tablet_mac, size: 15),
                  tooltip: 'Tablet View (768px)',
                ),
                ButtonSegment<String>(
                  value: 'desktop',
                  icon: Icon(Icons.computer, size: 15),
                  tooltip: 'Desktop View (100%)',
                ),
              ],
              selected: {currentDevice},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) onDeviceChanged(set.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ),
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Zoom Controls
            IconButton(
              icon: const Icon(Icons.zoom_out, size: 18),
              tooltip: 'Zoom Out',
              onPressed: onZoomOut,
              visualDensity: VisualDensity.compact,
            ),
            InkWell(
              onTap: onResetZoom,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                child: Text(
                  '${(currentZoom * 100).toInt()}%',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in, size: 18),
              tooltip: 'Zoom In',
              onPressed: onZoomIn,
              visualDensity: VisualDensity.compact,
            ),
            const VerticalDivider(width: 16, indent: 8, endIndent: 8),

            // Console toggle with Badge
            Badge(
              isLabelVisible: errorCount > 0,
              label: Text('$errorCount'),
              backgroundColor: Colors.redAccent,
              child: IconButton(
                icon: Icon(
                  Icons.terminal,
                  size: 18,
                  color: isConsoleOpen ? theme.colorScheme.primary : null,
                ),
                tooltip: 'Developer Console',
                onPressed: onToggleConsole,
                visualDensity: VisualDensity.compact,
              ),
            ),

            // Fullscreen Button
            IconButton(
              icon: Icon(
                isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                size: 20,
              ),
              tooltip: isFullscreen ? 'Exit Fullscreen' : 'Fullscreen Preview (↗)',
              onPressed: onToggleFullscreen,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
