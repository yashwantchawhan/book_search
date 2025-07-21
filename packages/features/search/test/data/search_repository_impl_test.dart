import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/data/search_repository_impl.dart';
import 'package:remote/api_service.dart';
import 'package:local_db/book.dart';
import 'package:dio/dio.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late SearchRepositoryImpl repository;

  setUp(() {
    mockApiService = MockApiService();
    repository = SearchRepositoryImpl(apiService: mockApiService);
  });

  const query = 'flutter';
  const page = 1;
  const limit = 10;

  final mockDocs = [
    {
      'key': '1',
      'title': 'Book 1',
      'author_name': ['Author 1'],
      'cover_i': 'cover1',
      'first_sentence': 'desc',
    },
    {
      'key': '2',
      'title': 'Book 2',
      'author_name': ['Author 2'],
      'cover_i': 'cover2',
      'first_sentence': 'desc',
    },
  ];

  test('returns list of books when response is valid', () async {
    final mockResponse = Response(
      requestOptions: RequestOptions(),
      data: {'docs': mockDocs},
      statusCode: 200,
    );

    when(
          () => mockApiService.get(
        any(),
        baseUrl: any(named: 'baseUrl'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => mockResponse);

    final result = await repository.searchBook(query, page, limit);

    expect(result, isA<List<Book>>());
    expect(result.length, 2);
    expect(result[0].title, 'Book 1');
    expect(result[1].title, 'Book 2');

    verify(() => mockApiService.get(
      '/search.json',
      baseUrl: 'https://openlibrary.org',
      queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
      },
    )).called(1);
  });

  test('throws exception when response is null', () async {
    when(
          () => mockApiService.get(
        any(),
        baseUrl: any(named: 'baseUrl'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => null);

    expect(
          () => repository.searchBook(query, page, limit),
      throwsA(isA<Exception>()),
    );
  });

  test('throws exception when response.data is null', () async {
    final mockResponse = Response(
      requestOptions: RequestOptions(),
      data: null,
      statusCode: 200,
    );

    when(
          () => mockApiService.get(
        any(),
        baseUrl: any(named: 'baseUrl'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => mockResponse);

    expect(
          () => repository.searchBook(query, page, limit),
      throwsA(isA<Exception>()),
    );
  });
}
