import 'dart:io';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/view/screens/PdfViewerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PdfViewerData {
  final String? filePath; // local path if available
  final String? remoteUrl; // remote URL (http/https) if provided
  final String title;


  PdfViewerData({this.filePath, this.remoteUrl, required this.title});
}

class PdfViewerProvider extends ChangeNotifier {
  PdfViewerData? _data;
  bool _loading = false;
  String? _error;
  int _pages = 0;
  int _currentPage = 0;

  PdfViewerData? get data => _data;
  bool get loading => _loading;
  String? get error => _error;
  int get pages => _pages;
  int get currentPage => _currentPage;

  // Public helpers for the viewer to update render state
  void updatePages(int pages) {
    _pages = pages;
    notifyListeners();
  }

  void reportError(String err) {
    _error = err;
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  BuildContext? context;
  Future<void> setData(PdfViewerData newData, BuildContext context) async {
    this.context = context;
    _data = newData;
    _error = null;
    _pages = 0;
    _currentPage = 0;
    notifyListeners();

    // If remoteUrl provided and no local filePath, download it
    if ((_data?.filePath == null || _data!.filePath!.isEmpty) &&
        (_data?.remoteUrl != null && _data!.remoteUrl!.isNotEmpty)) {
      downloadAndOpenByUrl(_data?.remoteUrl, _data?.title);
    }
  }

  Future<void> downloadAndOpenByUrl(String? url, String? title) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context!);
    Logger.logger('open == ');

    try {
      // 🧩 تجهيز اسم الملف المقترح
      final suggestedName =
          title!.replaceAll(' ', '_') + _extensionFromUrl(url!);

      // 📂 تحديد مجلد التطبيق
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, suggestedName);
      final file = File(path);

      // ✅ تحقق إذا الملف موجود أصلاً
      if (await file.exists()) {
        Logger.logger('📂 الملف موجود مسبقاً في: $path');
        debugPrint('📂 الملف موجود مسبقاً في: $path');
        _openFile(context!, file.path, title, scaffoldMessenger);
        return;
      }

      // 🌀 عرض مؤشر التحميل
      showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // ⬇️ تنزيل الملف
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        Navigator.pop(context!);
        throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
      }

      // 💾 حفظ الملف داخل مجلد التطبيق
      await file.writeAsBytes(response.bodyBytes);

      // ✅ إغلاق المؤشر
      Navigator.pop(context!);

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('تم تنزيل الملف: ${file.path}')),
      );

      // 📖 فتح الملف بعد التنزيل
      _openFile(context!, file.path, title, scaffoldMessenger);
    } catch (e, st) {
      debugPrint('❌ Error downloading file: $e\n$st');
      try {
        Navigator.pop(context!);
      } catch (_) {}
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
      );
    }
  }

  void _openFile(
    BuildContext context,
    String filePath,
    String title,
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    if (_extensionFromUrl(filePath).toLowerCase().contains('pdf')) {
      Navigator.pushNamed(
        context,
        PdfViewerScreen.route,
        arguments: PdfViewerData(filePath: filePath, title: title),
      );
    } else {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('تعذر فتح الملف: ${result.message}')),
        );
      }
    }
  }

  String _extensionFromUrl(String url) {
    final uri = Uri.parse(url);
    final path = uri.path;
    return p.extension(path);
  }
}
