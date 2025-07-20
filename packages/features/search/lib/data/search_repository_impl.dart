import 'package:local_db/book.dart';
import 'package:remote/api_service.dart';
import 'package:search/domain/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final ApiService apiService;

  SearchRepositoryImpl({required this.apiService});

  @override
  Future<List<Book>> searchBook(String query, int page, int limit) async {
    const url =
        '/search.json'; // endpoint only — baseUrl is handled by ApiService
    final params = {
      'q': query,
      'page': page,
      'limit': limit,
    };

    final response = await apiService.get(
      url,
      baseUrl: 'https://openlibrary.org',
      queryParameters: params,
    );

    if (response == null || response.data == null) {
      throw Exception("Failed to fetch books. No response.");
    }

    final data = response.data;
    final docs = List<Map<String, dynamic>>.from(data['docs'] ?? []);

    return docs.map<Book>((doc) {
      return Book.fromJson(doc);
    }).toList();
  }
}
