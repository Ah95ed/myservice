class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final String urlBook;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.urlBook,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',
      author: json['author'] ?? json['writer'] ?? 'غير معروف',
      imageUrl: json['imageUrl'] ?? json['cover'] ?? '',
      description: json['description'] ?? '',
      urlBook: json['url'] ?? json['fileUrl'] ?? '',
    );
  }
}
