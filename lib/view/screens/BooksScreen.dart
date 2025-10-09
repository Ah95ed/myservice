import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../../Models/BookModel.dart';
import '../../Service/CloudflareService.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<Book> books = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final list = await CloudflareService.fetchBooks();
      setState(() {
        books = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('الكتب')),
        body: Center(child: Text('خطأ: $error')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الكتب'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.book, size: 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            log('open ${book.urlBook}');
                            await downloadAndOpenByUrl(
                              context,
                              book.urlBook,
                              book.title,
                            );
                          },
                          child: Text(
                            book.title,
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
                        Text(
                          book.author,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.description,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              log('download ${book.urlBook}');
                              await downloadAndOpenByUrl(
                                context,
                                book.urlBook,
                                book.title,
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
            );
          },
        ),
      ),
    );
  }
}

Future<void> downloadAndOpenByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    // if (Platform.isAndroid) {
    //   await Permission.storage.request();
    //   await Permission.manageExternalStorage.request();
    //   await Permission.accessMediaLocation.request();
    // }

    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);

    // Ask for directory first (works on Android & desktop). If null, fallback to temp.
    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'اختر مجلد لحفظ الملف',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }
    final bytes = response.bodyBytes;

    String savedPath;
    if (dir != null) {
      final path = p.join(dir, suggestedName);
      final file = File(path);
      await file.writeAsBytes(bytes);
      savedPath = path;
    } else {
      final tmp = await Directory.systemTemp.createTemp('myservice_');
      final path = p.join(tmp.path, suggestedName);
      final file = File(path);
      await file.writeAsBytes(bytes);
      savedPath = path;
    }

    try {
      Navigator.pop(context);
    } catch (_) {}

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الكتاب: $savedPath')),
    );
    await OpenFile.open(savedPath);
  } catch (e, st) {
    try {
      Navigator.pop(context);
    } catch (_) {}
    log('download error', error: e, stackTrace: st);
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

String _extensionFromUrl(String url) {
  final idx = url.lastIndexOf('.');
  if (idx == -1) return '.pdf';
  return url.substring(idx);
}
