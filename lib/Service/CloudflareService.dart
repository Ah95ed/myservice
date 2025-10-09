import '../Models/BookModel.dart';

class CloudflareService {
  // NOTE: This service no longer calls a remote API.
  // Instead it returns a static list of book records with direct URLs.
  // When you upload files to Cloudflare R2 or host them somewhere, add
  // the direct public/signed URLs below in the `_booksData` list.

  static final List<Map<String, dynamic>> _booksData = [
    {
      'id': '1',
      'title': 'كتاب البرمجة الحديثة',
      'author': 'أحمد شاكر',
      'imageUrl': 'https://covers.openlibrary.org/b/id/10523338-L.jpg',
      'description':
          'دليل عملي لتعلم البرمجة الحديثة وأساسيات تطوير البرمجيات.',
      // Example R2 URL (replace with your actual uploaded file URL)
      'url':
          'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/book.pdf',
    },
    {
      'id': '2',
      'title': 'أساسيات تطوير التطبيقات',
      'author': 'سارة علي',
      'imageUrl': 'https://covers.openlibrary.org/b/id/11153223-L.jpg',
      'description': 'كل ما تحتاجه للبدء في تطوير تطبيقات الموبايل والويب.',
      'url':
          'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/book.pdf',
    },
  ];

  /// Return the static list of books. Edit `_booksData` to add/remove entries.
  static Future<List<Book>> fetchBooks() async {
    // simulate a slight delay so UI shows loading spinner briefly
    await Future.delayed(const Duration(milliseconds: 200));
    return _booksData.map((e) => Book.fromJson(e)).toList();
  }
}
