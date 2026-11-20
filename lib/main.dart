import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const FastDropEditorApp());

class FastDropEditorApp extends StatelessWidget {
  const FastDropEditorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FastDrop UI Editor', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF07090B),
      colorScheme: const ColorScheme.dark(primary: Color(0xFFB7FF62), secondary: Color(0xFFB7FF62)),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF07090B), foregroundColor: Colors.white),
    ), home: const EditorScreen());
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final WebViewController _controller;
  bool _ready = false;
  String _status = 'Загрузка редактора…';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('EditorBridge', onMessageReceived: _onBridgeMessage)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) { if (mounted) setState(() { _ready = true; _status = 'Редактор готов'; }); },
        onWebResourceError: (e) { if (mounted) setState(() => _status = 'Ошибка загрузки: ${e.description}'); },
      ));
    _loadEditor();
  }

  Future<void> _loadEditor() async {
    final html = await rootBundle.loadString('assets/editor/index.html');
    await _controller.loadHtmlString(html, baseUrl: 'https://fastdrop.local/');
  }

  Future<void> _onBridgeMessage(JavaScriptMessage message) async {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      if (data['type'] != 'export') return;
      final name = data['name'] as String? ?? 'fastdrop-export.txt';
      final content = data['content'] as String? ?? '';
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsString(content, flush: true);
      await Share.shareXFiles([XFile(file.path, mimeType: data['mime'] as String?)], text: 'Экспорт из FastDrop UI Editor');
      if (mounted) setState(() => _status = 'Подготовлен файл $name');
    } catch (e) {
      if (mounted) setState(() => _status = 'Не удалось экспортировать файл');
    }
  }

  Future<void> _importProject() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'], withData: true);
    if (result == null || result.files.single.bytes == null) return;
    final raw = utf8.decode(result.files.single.bytes!);
    final encoded = jsonEncode(raw);
    await _controller.runJavaScript('window.importProjectJson($encoded)');
    if (mounted) setState(() => _status = 'Импорт завершён');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('⚡ FastDrop UI Editor', style: TextStyle(fontWeight: FontWeight.w700)),
      actions: [IconButton(tooltip: 'Открыть JSON-проект', onPressed: _ready ? _importProject : null, icon: const Icon(Icons.folder_open_rounded))]),
    body: SafeArea(child: Column(children: [
      Expanded(child: WebViewWidget(controller: _controller)),
      Container(height: 34, padding: const EdgeInsets.symmetric(horizontal: 14), alignment: Alignment.centerLeft,
        color: const Color(0xFF11161B), child: Text(_status, style: const TextStyle(fontSize: 11, color: Color(0xFF9AA6B2)))),
    ])),
  );
}
