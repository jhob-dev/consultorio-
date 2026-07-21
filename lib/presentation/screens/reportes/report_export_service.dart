import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportExportService {
  static String escapeCsv(String text) {
    final safeText = text.replaceAll('"', '""');
    return '"$safeText"';
  }

  static Future<Directory> _getStorageDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) return directory;
    }
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> createCsvFile(String fileName, String content) async {
    final dir = await _getStorageDirectory();
    final file = File('${dir.path}/$fileName.csv');
    return file.writeAsString(content, flush: true);
  }

  static Future<File> createWordFile(String fileName, String htmlContent) async {
    final dir = await _getStorageDirectory();
    final file = File('${dir.path}/$fileName.doc');
    return file.writeAsString(htmlContent, flush: true);
  }

  static Future<File> saveFile(File file) async {
    final dir = await _getStorageDirectory();
    final targetPath = '${dir.path}/${file.uri.pathSegments.last}';
    final targetFile = File(targetPath);
    if (file.path != targetFile.path) {
      return file.copy(targetFile.path);
    }
    return file;
  }

  static Future<void> shareFile(File file, String subject) async {
    await Share.shareXFiles([XFile(file.path)], text: subject);
  }

  static String buildWordHtml(String title, String body) {
    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>$title</title>
<style>
  body { font-family: Arial, sans-serif; margin: 24px; color: #222; }
  h1 { color: #1c3f72; }
  h2 { color: #305c8f; }
  table { width: 100%; border-collapse: collapse; margin-bottom: 16px; }
  th, td { border: 1px solid #ccd7e3; padding: 8px; text-align: left; }
  th { background: #e9f0fb; }
  .section { margin-bottom: 24px; }
</style>
</head>
<body>
<h1>$title</h1>
$body
</body>
</html>
''';
  }
}
