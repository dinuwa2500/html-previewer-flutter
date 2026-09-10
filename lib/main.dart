import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/storage/storage_service.dart';
import 'features/editor/presentation/editor_controller.dart';
import 'features/history/presentation/history_controller.dart';
import 'features/preview/presentation/preview_controller.dart';
import 'features/settings/presentation/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  final storage = await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsController(storage)),
        ChangeNotifierProvider(create: (_) => HistoryController(storage)),
        ChangeNotifierProvider(create: (_) => EditorController(storage)),
        ChangeNotifierProvider(create: (_) => PreviewController()),
      ],
      child: const HtmlViewerApp(),
    ),
  );
}
