import 'package:flutter_test/flutter_test.dart';
import 'package:fastdrop_ui_editor/main.dart';

void main() {
  testWidgets('App starts and shows FastDrop UI Editor', (WidgetTester tester) async {
    await tester.pumpWidget(const FastDropUiEditorApp());
    await tester.pump();

    expect(find.text('FastDrop UI Editor'), findsOneWidget);
  });
}
