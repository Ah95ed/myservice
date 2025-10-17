import 'dart:developer';
import 'dart:io';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart' show OpenFilex, ResultType;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../provider/PdfViewerProvider.dart';
import 'PdfViewerScreen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  bool loading = true;
  String? error;

  List args = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as List;
  
  }

  @override
  Widget build(BuildContext context) {
    if (args.isEmpty)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('الكتب'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.99,
          ),
          itemCount: args.length,
          itemBuilder: (context, index) {
            final book = args;
            // log('message == ${book}');

            return InkWell(
              onTap: () async {
              

                final suggestedName =
                    book[index]['name'].replaceAll(' ', '_') +
                    _extensionFromUrl(book[index]['url']);
                log('message===$suggestedName');
                // 📂 تحديد مجلد التطبيق
                final dir = await getApplicationDocumentsDirectory();
                final path = p.join(dir.path, suggestedName);
                final file = File(path);

                // ✅ تحقق إذا الملف موجود أصلاً
                if (await file.exists()) {
                  managerScreen(
                    PdfViewerScreen.route,
                    context,
                    object: PdfViewerData(
                      filePath: path,
                      title: book[index]['name'],
                      remoteUrl: book[index]['url'],
                    ),
                  );
                  return;
                }
                downloadByUrl(
                  context,
                  book[index]['url'],
                  book[index]['name'],
                ).then((s) {
                  managerScreen(
                    PdfViewerScreen.route,
                    context,
                    object: PdfViewerData(
                      filePath: path,
                      title: book[index]['name'],
                      remoteUrl: book[index]['url'],
                    ),
                  );
                });
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              book[index]['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // log('download ${book.urlBook}');
                                await downloadAndOpenByUrl(
                                  context,
                                  book[index]['url']!,
                                  book[index]['name']!,
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('اختر مكان التنزيل'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

// 🔧 استخراج الامتداد من الرابط
String _extensionFromUrl(String url) {
  final uri = Uri.parse(url);
  final path = uri.path;
  return p.extension(path);
}

Future<void> downloadAndOpenByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // 🧩 تجهيز اسم الملف المقترح
    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);

    // 📂 تحديد مجلد التطبيق
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, suggestedName);
    final file = File(path);

    // ✅ تحقق إذا الملف موجود أصلاً
    if (await file.exists()) {
      debugPrint('📂 الملف موجود مسبقاً في: $path');
      _openFile(context, file.path, title, scaffoldMessenger);
      return;
    }

    // 🌀 عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // ⬇️ تنزيل الملف
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }

    // 💾 حفظ الملف داخل مجلد التطبيق
    await file.writeAsBytes(response.bodyBytes);

    // ✅ إغلاق المؤشر
    Navigator.pop(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الملف: ${file.path}')),
    );

    // 📖 فتح الملف بعد التنزيل
    _openFile(context, file.path, title, scaffoldMessenger);
  } catch (e, st) {
    debugPrint('❌ Error downloading file: $e\n$st');
    try {
      Navigator.pop(context);
    } catch (_) {}
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

Future<void> downloadByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // 🧩 تجهيز اسم الملف المقترح
    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);

    // 📂 تحديد مجلد التطبيق
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, suggestedName);
    final file = File(path);

    // ✅ تحقق إذا الملف موجود أصلاً
    if (await file.exists()) {
      debugPrint('📂 الملف موجود مسبقاً في: $path');
      _openFile(context, file.path, title, scaffoldMessenger);
      return;
    }

    // 🌀 عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // ⬇️ تنزيل الملف
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }

    // 💾 حفظ الملف داخل مجلد التطبيق
    await file.writeAsBytes(response.bodyBytes);

    // ✅ إغلاق المؤشر
    Navigator.pop(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الملف: ${file.path}')),
    );

    // 📖 فتح الملف بعد التنزيل
    // _openFile(context, file.path, title, scaffoldMessenger);
  } catch (e, st) {
    debugPrint('❌ Error downloading file: $e\n$st');
    try {
      Navigator.pop(context);
    } catch (_) {}
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

// String _extensionFromUrl(String url) {
//   final idx = url.lastIndexOf('.');
//   if (idx == -1) return '.pdf';
//   return url.substring(idx);
// }
