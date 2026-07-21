import 'package:flutter/material.dart';

class ReportPreviewScreen extends StatelessWidget {
  final String title;
  final String fileName;
  final String content;
  final List<Widget>? actions;

  const ReportPreviewScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Archivo: $fileName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
