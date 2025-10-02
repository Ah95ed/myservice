import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final String urlBook;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.urlBook,
  });
}

class BooksScreen extends StatelessWidget {
  BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  final List<Book> books = [
    Book(
      title: 'كتاب البرمجة الحديثة',
      author: 'أحمد شاكر',
      imageUrl: 'https://covers.openlibrary.org/b/id/10523338-L.jpg',
      description: 'دليل عملي لتعلم البرمجة الحديثة وأساسيات تطوير البرمجيات.',
      urlBook:
          'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D9%86%D8%AF%20(88).docx',
    ),
    Book(
      title: 'أساسيات تطوير التطبيقات',
      author: 'سارة علي',
      imageUrl: 'https://covers.openlibrary.org/b/id/11153223-L.jpg',
      description: 'كل ما تحتاجه للبدء في تطوير تطبيقات الموبايل والويب.',
      urlBook:
          'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D9%86%D8%AF%20(88).docx',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                              await downloadAndOpenBook(context, book);
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

Future<void> downloadAndOpenBook(BuildContext context, Book book) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    // 1. يختار المستخدم مكان الحفظ
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'اختر مكان حفظ الكتاب',
      fileName: book.title,
      type: FileType.any,
      allowedExtensions: ['pdf', 'docx', 'doc'],
    );
    if (savePath == null) {
      // المستخدم ألغى
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final response = await http.get(Uri.parse(book.urlBook));
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      Navigator.pop(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('تم تنزيل الكتاب!')),
      );
      await OpenFile.open(savePath);
    } else {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف');
    }
  } catch (e) {
    Navigator.pop(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}
