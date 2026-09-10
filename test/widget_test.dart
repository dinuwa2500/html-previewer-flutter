import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/app/app.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/editor/presentation/editor_controller.dart';
import 'package:app/features/history/presentation/history_controller.dart';
import 'package:app/features/preview/presentation/preview_controller.dart';
import 'package:app/features/settings/presentation/settings_controller.dart';

void main() {
  testWidgets('App smoke test loads editor and UI', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();

    await tester.pumpWidget(
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

    // Initial pump
    await tester.pumpAndSettle();

    // Verify main components exist
    expect(find.text('HTML Viewer'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
  });
}
