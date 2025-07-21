import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:search/domain/search_repository.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_events.dart';
import 'package:search/presentation/bloc/search_states.dart';
import 'package:local_db/book.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchRepository();
  });

  const query = 'flutter';
  const page = 1;
  const limit = 10;

  final mockBooks = [
    Book(
      key: '1',
      title: 'Book 1',
      author: 'Author 1',
      coverUrl: 'url1',
      description: 'desc',
    ),
    Book(
      key: '2',
      title: 'Book 2',
      author: 'Author 2',
      coverUrl: 'url2',
      description: 'desc',
    ),
  ];

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoadedState] when repository returns books',
    build: () {
      when(() => mockRepository.searchBook(query, page, limit))
          .thenAnswer((_) async => mockBooks);
      return SearchBloc(mockRepository);
    },
    act: (bloc) => bloc.add(FetchBooksEvent(query: query, page: page, limit: limit)),
    expect: () => [
      isA<SearchLoadedState>()
          .having((state) => state.books, 'books', mockBooks)
          .having((state) => state.isLastPage, 'isLastPage', true), // <-- fixed
    ],
    verify: (_) {
      verify(() => mockRepository.searchBook(query, page, limit)).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchErrorState] when repository throws an error',
    build: () {
      when(() => mockRepository.searchBook(query, page, limit))
          .thenThrow(Exception('Something went wrong'));
      return SearchBloc(mockRepository);
    },
    act: (bloc) => bloc.add(FetchBooksEvent(query: query, page: page, limit: limit)),
    expect: () => [
      isA<SearchErrorState>()
          .having((state) => state.errorMessage, 'message', contains('Something went wrong')),
    ],
    verify: (_) {
      verify(() => mockRepository.searchBook(query, page, limit)).called(1);
    },
  );
}
