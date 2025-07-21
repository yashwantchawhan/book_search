import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/book.dart';
import 'package:book_details/presentation/bloc/book_detail_event.dart';

void main() {
  group('FetchBookDetailsEvent', () {
    test('props are correct', () {
      const key = 'work_123';
      const coverUrl = 'cover.jpg';
      const author = 'Author Name';

      final event = FetchBookDetailsEvent(
        key: key,
        coverUrl: coverUrl,
        author: author,
      );

      expect(event.key, key);
      expect(event.coverUrl, coverUrl);
      expect(event.author, author);
    });
  });

  group('SaveBookEvent', () {
    test('props are correct', () {
      final book = Book(
        key: 'work_123',
        title: 'Test Title',
        author: 'Author Name',
        coverUrl: 'cover.jpg',
        description: 'description',
      );

      final event = SaveBookEvent(book: book);

      expect(event.book, book);
    });
  });

  group('DeleteBookEvent', () {
    test('props are correct', () {
      final book = Book(
        key: 'work_123',
        title: 'Test Title',
        author: 'Author Name',
        coverUrl: 'cover.jpg',
        description: 'description',
      );

      final event = DeleteBookEvent(book: book);

      expect(event.book, book);
    });
  });
}
