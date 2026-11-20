import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('bundled editor contains the main editor interface', () async {
    final html = await rootBundle.loadString('assets/editor/index.html');
    expect(html, contains('FastDrop UI Editor'));
    expect(html, contains('function importProjectJson'));
    expect(html, contains('function downloadCSS'));
  });
}
