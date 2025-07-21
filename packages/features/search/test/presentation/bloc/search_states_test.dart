import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/bloc/search_states.dart';
import 'package:local_db/book.dart';

void main() {
  group('SearchState', () {
    test('SearchLoadingState can be created', () {
      final state = SearchLoadingState();
      expect(state, isA<SearchLoadingState>());
    });

    test('SearchLoadedState holds correct books and isLastPage', () {
      final books = [
        Book(
          key: '1',
          title: 'Book 1',
          author: 'Author 1',
          coverUrl: 'url1',
          description: 'desc',
        )
      ];
      final state = SearchLoadedState(books: books, isLastPage: true);

      expect(state.books, books);
      expect(state.isLastPage, true);
    });

    test('SearchErrorState holds correct error message', () {
      final state = SearchErrorState('Something went wrong');
      expect(state.errorMessage, 'Something went wrong');
    });
  });
}
