import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/services/console_bridge.dart';
import '../../../models/console_log.dart';
import '../../editor/presentation/editor_controller.dart';
import '../widgets/console_panel.dart';
import '../widgets/device_frame_container.dart';
import '../widgets/preview_toolbar.dart';
import 'preview_controller.dart';

class PreviewView extends StatefulWidget {
  const PreviewView({super.key});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  WebViewController? _webViewController;
  bool _isWebViewSupported = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWebView();
    });
  }

  void _initWebView() {
    final preview = context.read<PreviewController>();
    final editor = context.read<EditorController>();

    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => preview.setLoading(true),
            onPageFinished: (_) {
              preview.setLoading(false);
            },
            onWebResourceError: (error) {
              preview.setLoadError(error.description);
            },
          ),
        )
        ..setOnConsoleMessage((msg) {
          ConsoleLogLevel level = ConsoleLogLevel.info;
          if (msg.level == JavaScriptLogLevel.error) {
            level = ConsoleLogLevel.error;
          } else if (msg.level == JavaScriptLogLevel.warning) {
            level = ConsoleLogLevel.warn;
          }
          preview.addLog(
            ConsoleLog(
              id: UniqueKey().toString(),
              level: level,
              message: msg.message,
              timestamp: DateTime.now(),
            ),
          );
        })
        ..addJavaScriptChannel(
          ConsoleBridge.channelName,
          onMessageReceived: (message) {
            try {
              final decoded = jsonDecode(message.message) as Map<String, dynamic>;
              final levelStr = decoded['level'] as String?;
              final msg = decoded['message'] as String? ?? '';
              ConsoleLogLevel level = ConsoleLogLevel.info;
              if (levelStr == 'error') level = ConsoleLogLevel.error;
              if (levelStr == 'warn') level = ConsoleLogLevel.warn;

              preview.addLog(
                ConsoleLog(
                  id: UniqueKey().toString(),
                  level: level,
                  message: msg,
                  timestamp: DateTime.now(),
                ),
              );
            } catch (_) {}
          },
        );

      setState(() {
        _webViewController = controller;
      });

      preview.attachWebViewController(controller);

      // Initial run of current code
      final initialHtml = preview.currentRenderedHtml.isNotEmpty
          ? preview.currentRenderedHtml
          : editor.code;
      preview.runHtml(initialHtml);
    } catch (e) {
      setState(() {
        _isWebViewSupported = false;
        _initError = e.toString();
      });
      preview.setLoadError('WebView initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = context.watch<PreviewController>();

    return Column(
      children: [
        // Preview Toolbar
        PreviewToolbar(
          currentDevice: preview.deviceMode,
          onDeviceChanged: preview.setDeviceMode,
          currentZoom: preview.zoomLevel,
          onZoomIn: preview.zoomIn,
          onZoomOut: preview.zoomOut,
          onResetZoom: preview.resetZoom,
          onRefresh: preview.reload,
          onToggleFullscreen: preview.toggleFullscreen,
          isFullscreen: preview.isFullscreen,
          onToggleConsole: preview.toggleConsole,
          isConsoleOpen: preview.isConsoleOpen,
          errorCount: preview.errorCount,
        ),

        // Preview Area with Loading Bar
        if (preview.isLoading)
          const LinearProgressIndicator(minHeight: 2.5),

        // WebView or Unsupported Fallback View
        Expanded(
          child: _isWebViewSupported && _webViewController != null
              ? DeviceFrameContainer(
                  deviceMode: preview.deviceMode,
                  child: WebViewWidget(controller: _webViewController!),
                )
              : _buildFallbackView(preview),
        ),

        // Optional Console Panel
        if (preview.isConsoleOpen)
          ConsolePanel(
            logs: preview.consoleLogs,
            onClear: preview.clearLogs,
            onClose: preview.toggleConsole,
          ),
      ],
    );
  }

  Widget _buildFallbackView(PreviewController preview) {
    return Container(
      color: const Color(0xFF0F141C),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.web, size: 48, color: Color(0xFF6366F1)),
              const SizedBox(height: 16),
              const Text(
                'HTML Preview Renderer Ready',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _initError != null
                    ? 'Note: Platform WebView notice ($_initError). On mobile (Android/iOS) and supported desktop engines, full interactive WebView2/WebKit rendering is active.'
                    : 'Your HTML code is loaded and ready for rendering.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _initWebView(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry Initialization'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
