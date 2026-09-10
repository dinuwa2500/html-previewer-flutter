import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/services/console_bridge.dart';
import '../../../models/console_log.dart';

class PreviewController extends ChangeNotifier {
  String _currentRenderedHtml = '';
  String _deviceMode = 'desktop'; // 'mobile', 'tablet', 'desktop'
  double _zoomLevel = 1.0;
  bool _isLoading = false;
  bool _isConsoleOpen = false;
  bool _isFullscreen = false;
  String? _loadError;

  final List<ConsoleLog> _consoleLogs = [];

  WebViewController? _webViewController;

  String get currentRenderedHtml => _currentRenderedHtml;
  String get deviceMode => _deviceMode;
  double get zoomLevel => _zoomLevel;
  bool get isLoading => _isLoading;
  bool get isConsoleOpen => _isConsoleOpen;
  bool get isFullscreen => _isFullscreen;
  String? get loadError => _loadError;
  List<ConsoleLog> get consoleLogs => List.unmodifiable(_consoleLogs);
  WebViewController? get webViewController => _webViewController;

  int get errorCount =>
      _consoleLogs.where((l) => l.level == ConsoleLogLevel.error).length;
  int get warnCount =>
      _consoleLogs.where((l) => l.level == ConsoleLogLevel.warn).length;

  void attachWebViewController(WebViewController controller) {
    _webViewController = controller;
  }

  void setDeviceMode(String mode) {
    if (_deviceMode != mode) {
      _deviceMode = mode;
      notifyListeners();
    }
  }

  void zoomIn() {
    _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 2.0);
    _applyZoom();
    notifyListeners();
  }

  void zoomOut() {
    _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0);
    _applyZoom();
    notifyListeners();
  }

  void resetZoom() {
    _zoomLevel = 1.0;
    _applyZoom();
    notifyListeners();
  }

  void _applyZoom() {
    if (_webViewController != null) {
      // In webview_flutter, apply CSS zoom scaling for consistent rendering across platforms
      final js = 'document.body.style.zoom = "$_zoomLevel";';
      _webViewController?.runJavaScript(js).catchError((_) {});
    }
  }

  void toggleConsole() {
    _isConsoleOpen = !_isConsoleOpen;
    notifyListeners();
  }

  void toggleFullscreen() {
    _isFullscreen = !_isFullscreen;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setLoadError(String? error) {
    _loadError = error;
    if (error != null) {
      addLog(
        ConsoleLog(
          id: UniqueKey().toString(),
          level: ConsoleLogLevel.error,
          message: error,
          timestamp: DateTime.now(),
        ),
      );
    }
    notifyListeners();
  }

  void addLog(ConsoleLog log) {
    _consoleLogs.add(log);
    if (_consoleLogs.length > 200) {
      _consoleLogs.removeAt(0);
    }
    notifyListeners();
  }

  void clearLogs() {
    _consoleLogs.clear();
    notifyListeners();
  }

  /// Run or reload HTML inside the WebView
  Future<void> runHtml(String rawHtml) async {
    _currentRenderedHtml = rawHtml;
    _loadError = null;
    _isLoading = true;
    notifyListeners();

    // Injected with console interceptor
    final htmlWithBridge = ConsoleBridge.wrapHtml(rawHtml);

    if (_webViewController != null) {
      try {
        await _webViewController!.loadHtmlString(
          htmlWithBridge,
          baseUrl: 'https://localhost/',
        );
      } catch (e) {
        setLoadError('Failed to load HTML: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh current page
  Future<void> reload() async {
    if (_currentRenderedHtml.isNotEmpty) {
      await runHtml(_currentRenderedHtml);
    }
  }
}
