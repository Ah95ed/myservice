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

class BooksArgs {
  final String name;
  final List data;

  BooksArgs({required this.name, required this.data});
}

final Map<String, Map<String, List<Map<String, String>>>> books = {
  "primary": {
    "grade1": [
      {
        "name": "القراءة الأول",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الرياضيات الأول",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الاسلامية الأول",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%AA%D8%B1%D8%A8%D9%8A%D8%A9%20%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        'name': 'العلوم الأول',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        'name': 'الأخلاقية الأول',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%AA%D8%B1%D8%A8%D9%8A%D8%A9%20%D8%A7%D9%84%D8%A3%D8%AE%D9%84%D8%A7%D9%82%D9%8A%D8%A9%20%D8%A7%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        'name': 'اللغة الانجليزية الأول',
        'url':
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c1_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%A3%D9%88%D9%84%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
    ],
    "grade2": [
      {
        "name": "القراءة الثاني",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c2_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الرياضيات الثاني",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c2_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الأسلامية الثاني",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c2_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الانكليزي الثاني",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c2_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "العلوم الثاني",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c2_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
    ],
    "grade3": [
      {
        "name": "القراءة الثالث",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الرياضيات الثالث",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الأسلامية الثالث",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c3_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%84%D8%AB%20%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "الانكليزي الثالث",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "العلوم الثالث",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
    ],
    "grade4": [
      {
        "name": "الاجتماعيات الرابع",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D8%AC%D8%AA%D9%85%D8%A7%D8%B9%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "القواعد الرابع",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%82%D9%88%D8%A7%D8%B9%D8%AF%20%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "الرياضيات الرابع",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "الأسلامية الرابع",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf',
      },
      {
        "name": "الانكليزي الرابع",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "العلوم الرابع",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c4_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
    ],
    "grade5": [
      {
        "name": "الاجتماعيات الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D8%AC%D8%AA%D9%85%D8%A7%D8%B9%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "القواعد الخامس",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D9%82%D9%88%D8%A7%D8%B9%D8%AF%20%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf',
      },
      {
        "name": "القراءة الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "الرياضيات الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الأسلامية الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الانكليزي الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "العلوم الخامس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
    ],
    "grade6": [
      {
        "name": "الاجتماعيات السادس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D8%AC%D8%AA%D9%85%D8%A7%D8%B9%D9%8A%D8%A7%D8%AA%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "القواعد السادس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D9%82%D9%88%D8%A7%D8%B9%D8%AF%20%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf"
      },
      {
        "name": "القراءة السادس",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%82%D8%B1%D8%A7%D8%A1%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
      {
        "name": "الرياضيات السادس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الأسلامية السادس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86%20%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85%20%D9%88%D8%A7%D9%84%D8%A5%D8%B3%D9%84%D8%A7%D9%85%D9%8A%D8%A9%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A.pdf",
      },
      {
        "name": "الانكليزي السادس",
        "url":
            "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c5_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AE%D8%A7%D9%85%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf",
      },
      {
        "name": "نشاط انكليزي السادس",
        "url": "https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c6_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D9%86%D8%B4%D8%A7%D8%B7%20%D8%A7%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%B3%D8%A7%D8%AF%D8%B3%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf"
      },
      {
        "name": "العلوم السادس",
        "url":
            'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev/Books/c3_Primary/%D9%83%D8%AA%D8%A7%D8%A8%20%D8%A7%D9%84%D8%B9%D9%84%D9%88%D9%85%20%D9%84%D9%84%D8%B5%D9%81%20%D8%A7%D9%84%D8%AB%D8%A7%D9%84%D8%AB%20%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A%20.pdf',
      },
    ],
  },

  'middle': {
    "grade1": [
      {
        "name": "",
        "url": '',

      }],}, 
};