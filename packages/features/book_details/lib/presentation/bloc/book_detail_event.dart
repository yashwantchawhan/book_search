import 'package:local_db/book.dart';

abstract class BookDetailsEvent {}

class FetchBookDetailsEvent extends BookDetailsEvent {
  final String key;
  final String coverUrl;
  final String author;

  FetchBookDetailsEvent({
    required this.key,
    required this.coverUrl,
    required this.author,
  });
}

class SaveBookEvent extends BookDetailsEvent {
  final Book book;

  SaveBookEvent({
    required this.book,
  });
}

class DeleteBookEvent extends BookDetailsEvent {
  final Book book;

  DeleteBookEvent({
    required this.book,
  });
}
