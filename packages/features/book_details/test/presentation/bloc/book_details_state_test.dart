import 'package:flutter_test/flutter_test.dart';
import 'package:book_details/presentation/bloc/book_detail_state.dart';
import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:local_db/book.dart';

void main() {
  group('BookDetailsLoading', () {
    test('can be instantiated', () {
      final state = BookDetailsLoading();
      expect(state, isA<BookDetailsLoading>());
    });
  });

  group('BookDetailsLoaded', () {
    test('holds the correct BookDetailsDisplayModel', () {
      final book = Book(
        key: 'work_123',
        title: 'Test Title',
        author: 'Author Name',
        coverUrl: 'cover.jpg',
        description: 'desc',
      );

      final bookDetails = BookDetailsDisplayModel(book: book, isSaved: true);

      final state = BookDetailsLoaded(bookDetail: bookDetails);

      expect(state, isA<BookDetailsLoaded>());
      expect(state.bookDetail, bookDetails);
      expect(state.bookDetail.book.title, 'Test Title');
      expect(state.bookDetail.isSaved, true);
    });
  });

  group('BookDetailsError', () {
    test('holds the correct message', () {
      final state = BookDetailsError(message: 'Something went wrong');
      expect(state, isA<BookDetailsError>());
      expect(state.message, 'Something went wrong');
    });
  });

  group('BookSavedState', () {
    test('can be instantiated', () {
      final state = BookSavedState();
      expect(state, isA<BookSavedState>());
    });
  });

  group('DeleteBookState', () {
    test('can be instantiated', () {
      final state = DeleteBookState();
      expect(state, isA<DeleteBookState>());
    });
  });

  group('BookSavedError', () {
    test('holds the correct message', () {
      final state = BookSavedError(message: 'Failed to save');
      expect(state, isA<BookSavedError>());
      expect(state.message, 'Failed to save');
    });
  });
}
