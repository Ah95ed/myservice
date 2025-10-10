import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

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

  Future<void> setData(PdfViewerData newData) async {
    _data = newData;
    _error = null;
    _pages = 0;
    _currentPage = 0;
    notifyListeners();

    // If remoteUrl provided and no local filePath, download it
    if ((_data?.filePath == null || _data!.filePath!.isEmpty) &&
        (_data?.remoteUrl != null && _data!.remoteUrl!.isNotEmpty)) {
      await _downloadRemoteToTemp(_data!.remoteUrl!);
    }
  }

  Future<void> _downloadRemoteToTemp(String url) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _error = 'Failed to download PDF: ${response.statusCode}';
        _loading = false;
        notifyListeners();
        return;
      }
      final bytes = response.bodyBytes;
      final tmpDir = await Directory.systemTemp.createTemp('pdf_');
      final suggested = p.basename(Uri.parse(url).path);
      final name = suggested.isNotEmpty ? suggested : 'document.pdf';
      final file = File(p.join(tmpDir.path, name));
      await file.writeAsBytes(bytes);
      _data = PdfViewerData(
        filePath: file.path,
        remoteUrl: _data?.remoteUrl,
        title: _data?.title ?? 'PDF',
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
