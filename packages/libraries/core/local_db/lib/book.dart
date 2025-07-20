class Book {
  final String title;
  final String author;
  final String coverUrl;

  Book({required this.title, required this.author, required this.coverUrl});

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
    );
  }
}
