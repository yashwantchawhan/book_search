class Book {
  final String title;
  final String author;
  final String coverUrl;
  final String key;
  String? description = ""; // /works/OL27479W

  Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.key,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    String authorName = '';
    if (json['author_name'] != null) {
      authorName = (json['author_name'] as List).join(', ');
    }

    String coverUrl = '';
    if (json['cover_i'] != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg';
    }

    return Book(
      title: json['title'] ?? 'No title',
      author: authorName,
      coverUrl: coverUrl,
      key: json['key'] ?? '',
      description: json['description']?['value'] ?? "",
    );
  }
}
