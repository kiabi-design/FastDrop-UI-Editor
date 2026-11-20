// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FastDropUiEditorApp());
}

class FastDropUiEditorApp extends StatelessWidget {
  const FastDropUiEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastDrop UI Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07090B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB7FF62),
          brightness: Brightness.dark,
        ),
      ),
      home: const EditorAssetScreen(),
    );
  }
}

class EditorAssetScreen extends StatefulWidget {
  const EditorAssetScreen({super.key});

  @override
  State<EditorAssetScreen> createState() => _EditorAssetScreenState();
}

class _EditorAssetScreenState extends State<EditorAssetScreen> {
  late Future<String> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = rootBundle.loadString('assets/editor/index.html');
  }

  Future<void> _reloadAsset() async {
    setState(() {
      _htmlFuture = rootBundle.loadString('assets/editor/index.html');
    });
  }

  Future<void> _copyHtml(String html) async {
    await Clipboard.setData(ClipboardData(text: html));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('HTML редактора скопирован в буфер обмена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastDrop UI Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadAsset,
            tooltip: 'Обновить ресурс',
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _htmlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Ошибка загрузки assets/editor/index.html:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final htmlContent = snapshot.data ?? '';
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11161B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF29333C)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ресурс подключён',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB7FF62),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Путь: assets/editor/index.html'),
                      const SizedBox(height: 4),
                      Text('Размер шаблона: ${htmlContent.length} символов'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB7FF62),
                    foregroundColor: const Color(0xFF11170A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: htmlContent.isEmpty ? null : () => _copyHtml(htmlContent),
                  icon: const Icon(Icons.copy),
                  label: const Text('Скопировать HTML-шаблон'),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1115),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF252E36)),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        htmlContent,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
