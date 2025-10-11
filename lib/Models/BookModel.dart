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

final Map<String, Map<String, List<Map<String, String>>>> books = {
  "primary": {
    "grade1": [
      {
        "name": "القراءة",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الرياضيات",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الاسلامية",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%AA%D8%B1%D8%A8%D9%8A%D8%A9%20%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        'name': 'العلوم',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        'name': 'الأخلاقية',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%AA%D8%B1%D8%A8%D9%8A%D8%A9%20%D8%A7%D9%84%D8%A3%D8%AE%D9%84%D8%A7%D9%82%D9%8A%D8%A9%20%D8%A7%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        'name': 'اللغة الانجليزية',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%AA%D8%B1%D8%A8%D9%8A%D8%A9%20%D8%A7%D9%84%D8%A3%D8%AE%D9%84%D8%A7%D9%82%D9%8A%D8%A9%20%D8%A7%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
    ],
    "grade2": [
      {"name": "القراءة", "url": "https://example.com/primary2_reading.pdf"},
      {"name": "الرياضيات", "url": "https://example.com/primary2_math.pdf"},
    ],
  },
  "متوسطة": {
    "الصف الأول": [
      {"name": "الرياضيات", "url": "https://example.com/middle1_math.pdf"},
      {"name": "العلوم", "url": "https://example.com/middle1_science.pdf"},
    ],
    "الصف الثالث": [
      {
        "name": "اللغة العربية",
        "url": "https://example.com/middle3_arabic.pdf",
      },
      {"name": "الاجتماعيات", "url": "https://example.com/middle3_social.pdf"},
    ],
  },
  "إعدادية": {
    "الصف السادس العلمي": [
      {"name": "الفيزياء", "url": "https://example.com/high6_physics.pdf"},
      {"name": "الكيمياء", "url": "https://example.com/high6_chemistry.pdf"},
      {"name": "الأحياء", "url": "https://example.com/high6_biology.pdf"},
    ],
    "الصف السادس الأدبي": [
      {"name": "التاريخ", "url": "https://example.com/high6_history.pdf"},
      {"name": "اللغة العربية", "url": "https://example.com/high6_arabic.pdf"},
    ],
  },
};
