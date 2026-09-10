class ConsoleBridge {
  static const String channelName = 'FlutterConsole';

  /// Generates the injected script that hooks console methods and global errors,
  /// routing messages both to console.* (for setOnConsoleMessage) and to FlutterConsole channel.
  static String get injectionScript => '''
<script>
(function() {
  if (window.__flutterConsoleInjected) return;
  window.__flutterConsoleInjected = true;

  function postToFlutter(level, msg) {
    try {
      if (window.$channelName && window.$channelName.postMessage) {
        window.$channelName.postMessage(JSON.stringify({ level: level, message: String(msg) }));
      }
    } catch(e) {}
  }

  var origLog = console.log;
  var origWarn = console.warn;
  var origError = console.error;
  var origInfo = console.info;

  console.log = function() {
    var args = Array.prototype.slice.call(arguments).join(' ');
    postToFlutter('info', args);
    origLog.apply(console, arguments);
  };

  console.info = function() {
    var args = Array.prototype.slice.call(arguments).join(' ');
    postToFlutter('info', args);
    origInfo.apply(console, arguments);
  };

  console.warn = function() {
    var args = Array.prototype.slice.call(arguments).join(' ');
    postToFlutter('warn', args);
    origWarn.apply(console, arguments);
  };

  console.error = function() {
    var args = Array.prototype.slice.call(arguments).join(' ');
    postToFlutter('error', args);
    origError.apply(console, arguments);
  };

  window.addEventListener('error', function(event) {
    var errStr = 'Uncaught ' + (event.error ? (event.error.stack || event.error.message || event.message) : event.message);
    if (event.lineno) {
      errStr += ' (line ' + event.lineno + ')';
    }
    console.error(errStr);
  });

  window.addEventListener('unhandledrejection', function(event) {
    var reason = event.reason ? (event.reason.stack || event.reason.message || event.reason) : 'Unknown reason';
    console.error('Unhandled Promise Rejection: ' + reason);
  });

  window.addEventListener('DOMContentLoaded', function() {
    console.log('Page loaded');
  });
})();
</script>
''';

  /// Wrap the user's HTML with the console bridge script injected in the head or top
  static String wrapHtml(String originalHtml) {
    if (originalHtml.contains('<head>')) {
      return originalHtml.replaceFirst('<head>', '<head>\n$injectionScript');
    } else if (originalHtml.contains('<html>')) {
      return originalHtml.replaceFirst('<html>', '<html>\n<head>\n$injectionScript</head>');
    } else {
      return '$injectionScript\n$originalHtml';
    }
  }
}
