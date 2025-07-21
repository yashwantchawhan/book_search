import 'package:book_details/data/book_details_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:local_db/book.dart';
import 'package:local_db/local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService extends Mock implements ApiService {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late BookDetailsRepositoryImpl repository;
  late MockApiService mockApiService;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockApiService = MockApiService();
    mockLocalDataSource = MockLocalDataSource();
    repository = BookDetailsRepositoryImpl(
      apiService: mockApiService,
      localDataSource: mockLocalDataSource,
    );

    // register fallback values for argument matchers
    registerFallbackValue(Book(
      key: '',
      title: '',
      author: '',
      coverUrl: '',
      description: '',
    ));
  });

  const workKey = 'work_123';
  const coverUrl = 'cover.jpg';
  const author = 'Author Name';

  final cachedBook = Book(
    key: workKey,
    title: 'Cached Title',
    author: author,
    coverUrl: coverUrl,
    description: 'Cached description',
  );

  final apiResponseData = {
    'title': 'API Title',
    'description': 'API description'
  };

  test('returns cached book if available', () async {
    when(() => mockLocalDataSource.getBookByKey(workKey))
        .thenAnswer((_) async => cachedBook);

    final result = await repository.fetchBookDetails(workKey, coverUrl, author);

    expect(result.isSaved, true);
    expect(result.book.title, 'Cached Title');
    verifyNever(
        () => mockApiService.get(any(), baseUrl: any(named: 'baseUrl')));
  });

  test('fetches from API and saves when no cached book', () async {
    when(() => mockLocalDataSource.getBookByKey(workKey))
        .thenAnswer((_) async => null);

    final response = Response(
      data: apiResponseData,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

    when(() => mockApiService.get(
          '$workKey.json',
          baseUrl: 'https://openlibrary.org',
        )).thenAnswer((_) async => response);

    when(() => mockLocalDataSource.saveBook(any())).thenAnswer((_) async => {});

    final result = await repository.fetchBookDetails(workKey, coverUrl, author);

    expect(result.isSaved, false);
    expect(result.book.title, 'API Title');
    expect(result.book.description, 'API description');

    verify(() => mockApiService.get(
          '$workKey.json',
          baseUrl: 'https://openlibrary.org',
        )).called(1);

    verify(() => mockLocalDataSource.saveBook(any())).called(1);
  });

  test('throws when API response is null', () async {
    when(() => mockLocalDataSource.getBookByKey(workKey))
        .thenAnswer((_) async => null);

    when(() => mockApiService.get(any(), baseUrl: any(named: 'baseUrl')))
        .thenAnswer((_) async => null);

    expect(
      () => repository.fetchBookDetails(workKey, coverUrl, author),
      throwsException,
    );
  });
}
