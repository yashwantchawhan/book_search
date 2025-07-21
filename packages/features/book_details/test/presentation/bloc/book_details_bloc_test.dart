import 'package:bloc_test/bloc_test.dart';
import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:book_details/domain/book_details_repository.dart';
import 'package:book_details/presentation/bloc/book_detail_bloc.dart';
import 'package:book_details/presentation/bloc/book_detail_event.dart';
import 'package:book_details/presentation/bloc/book_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/book.dart';
import 'package:local_db/local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockBookDetailsRepository extends Mock implements BookDetailsRepository {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late BookDetailsBloc bloc;
  late MockBookDetailsRepository mockRepository;
  late MockLocalDataSource mockLocalDataSource;

  const workKey = 'work_123';
  const coverUrl = 'cover.jpg';
  const author = 'Author Name';

  final book = Book(
    key: workKey,
    title: 'Test Title',
    author: author,
    coverUrl: coverUrl,
    description: 'Description',
  );

  final bookDetails = BookDetailsDisplayModel(book: book, isSaved: false);

  setUp(() {
    mockRepository = MockBookDetailsRepository();
    mockLocalDataSource = MockLocalDataSource();

    bloc = BookDetailsBloc(mockRepository, mockLocalDataSource);
  });

  tearDown(() {
    bloc.close();
  });

  group('FetchBookDetailsEvent', () {
    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, Loaded] when repository returns book details',
      build: () {
        when(() => mockRepository.fetchBookDetails(workKey, coverUrl, author))
            .thenAnswer((_) async => bookDetails);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchBookDetailsEvent(
        key: workKey,
        coverUrl: coverUrl,
        author: author,
      )),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<BookDetailsLoaded>()
            .having((state) => state.bookDetail, 'bookDetail', bookDetails),
      ],
    );

    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, Error] when repository throws',
      build: () {
        when(() => mockRepository.fetchBookDetails(workKey, coverUrl, author))
            .thenThrow(Exception('Failed to fetch'));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchBookDetailsEvent(
        key: workKey,
        coverUrl: coverUrl,
        author: author,
      )),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<BookDetailsError>()
            .having((state) => state.message, 'message', contains('Failed')),
      ],
    );
  });

  group('SaveBookEvent', () {
    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, Loaded] when book is saved successfully',
      build: () {
        when(() => mockLocalDataSource.isBookSaved(book))
            .thenAnswer((_) async => false);
        when(() => mockLocalDataSource.saveBook(book))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(SaveBookEvent(book: book)),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<BookDetailsLoaded>()
            .having((state) => state.bookDetail.book, 'book', book)
            .having((state) => state.bookDetail.isSaved, 'isSaved', true),
      ],
    );

    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, Error] when save fails',
      build: () {
        when(() => mockLocalDataSource.isBookSaved(book))
            .thenThrow(Exception('Failed to save'));
        return bloc;
      },
      act: (bloc) => bloc.add(SaveBookEvent(book: book)),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<BookSavedError>()
            .having((state) => state.message, 'message', contains('Failed')),
      ],
    );
  });

  group('DeleteBookEvent', () {
    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, DeleteBookState] when book is deleted',
      build: () {
        when(() => mockLocalDataSource.deleteBook(book))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteBookEvent(book: book)),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<DeleteBookState>(),
      ],
    );

    blocTest<BookDetailsBloc, BookDetailsState>(
      'emits [Loading, Error] when delete fails',
      build: () {
        when(() => mockLocalDataSource.deleteBook(book))
            .thenThrow(Exception('Failed to delete'));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteBookEvent(book: book)),
      expect: () => [
        isA<BookDetailsLoading>(),
        isA<BookSavedError>()
            .having((state) => state.message, 'message', contains('Failed')),
      ],
    );
  });
}
