class Book {
  final String title;

  final String urlBook;

  Book({required this.title, required this.urlBook});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',

      urlBook: json['url'] ?? json['fileUrl'] ?? '',
    );
  }
}

List<Book> c1_primary = [
  Book(
    title: 'قراءة',
    urlBook:
        'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf',
  ),
  
];
