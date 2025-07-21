import 'package:flutter_test/flutter_test.dart';

import 'package:home/domain/book_display_model.dart';
import 'package:home/data/get_books_repository_impl.dart';
import 'package:local_db/local_data_source.dart';
import 'package:local_db/book.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late GetBooksRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = GetBooksRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return a list of BookDisplayModel mapped from Book', () async {
    // Arrange
    final books = [
      Book(
        key: '1',
        title: 'Book Title 1',
        author: 'Author 1',
        coverUrl: 'https://example.com/cover1.jpg',
      ),
      Book(
        key: '2',
        title: 'Book Title 2',
        author: 'Author 2',
        coverUrl: "",
      ),
    ];

    when(() => mockLocalDataSource.getAllBooks())
        .thenAnswer((_) async => books);

    // Act
    final result = await repository.getAllBookMarkedBooks();

    // Assert
    expect(result, isA<List<BookDisplayModel>>());
    expect(result.length, 2);

    expect(result[0].key, '1');
    expect(result[0].title, 'Book Title 1');
    expect(result[0].author, 'Author 1');
    expect(result[0].url, 'https://example.com/cover1.jpg');

    expect(result[1].key, '2');
    expect(result[1].title, 'Book Title 2');
    expect(result[1].author, 'Author 2');
    expect(result[1].url, ''); // because coverUrl was null
  });
}
