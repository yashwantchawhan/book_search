import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:home/presenatation/bloc/book_bloc.dart';
import 'package:home/presenatation/bloc/book_event.dart';
import 'package:home/presenatation/bloc/book_state.dart';
import 'package:home/domain/book_display_model.dart';
import 'package:home/domain/get_books_repository.dart';

class MockGetBooksRepository extends Mock implements GetBooksRepository {}

void main() {
  late MockGetBooksRepository mockRepository;

  final booksList = [
    BookDisplayModel(
      url: 'https://example.com',
      title: 'Book 1',
      author: 'Author 1',
      key: '',
    ),
    BookDisplayModel(
      url: 'https://example.com/2',
      title: 'Book 2',
      author: 'Author 2',
      key: '',
    ),
  ];

  setUp(() {
    mockRepository = MockGetBooksRepository();
  });

  blocTest<BookBloc, BookState>(
    'emits [BooksLoading, BooksLoaded] when getAllBookMarkedBooks succeeds',
    build: () {
      when(() => mockRepository.getAllBookMarkedBooks())
          .thenAnswer((_) async => booksList);
      return BookBloc(getBooksRepository: mockRepository);
    },
    act: (bloc) => bloc.add(LoadBooksEvent()),
    expect: () => [
      BooksLoading(),
      BooksLoaded(booksList),
    ],
    verify: (_) {
      verify(() => mockRepository.getAllBookMarkedBooks()).called(1);
    },
  );

  blocTest<BookBloc, BookState>(
    'emits [BooksLoading, BooksError] when getAllBookMarkedBooks throws',
    build: () {
      when(() => mockRepository.getAllBookMarkedBooks())
          .thenThrow(Exception('Failed to fetch'));
      return BookBloc(getBooksRepository: mockRepository);
    },
    act: (bloc) => bloc.add(LoadBooksEvent()),
    expect: () => [
      BooksLoading(),
      isA<BooksError>()
          .having((e) => e.message, 'message', contains('Exception')),
    ],
    verify: (_) {
      verify(() => mockRepository.getAllBookMarkedBooks()).called(1);
    },
  );
}
