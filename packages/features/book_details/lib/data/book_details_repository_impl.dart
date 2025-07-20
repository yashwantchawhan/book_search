import 'package:book_details/domain/book_details_repository.dart';
import 'package:local_db/book.dart';
import 'package:remote/api_service.dart';

class BookDetailsRepositoryImpl extends BookDetailsRepository {
  final ApiService apiService;

  BookDetailsRepositoryImpl({required this.apiService});

  @override
  Future<Book> fetchBookDetails(String workKey, String? coverUrl, String? author) async {
    final url = '$workKey.json';

    final response = await apiService.get(
      url,
      baseUrl: 'https://openlibrary.org',
    );

    if (response == null || response.data == null) {
      throw Exception("Failed to fetch book details. No response.");
    }

    final json = response.data;

    String? desc;
    if (json['description'] is String) {
      desc = json['description'];
    } else if (json['description'] is Map) {
      desc = json['description']['value'];
    }

    return Book(
      key: workKey,
      title: json['title'] ?? 'No Title',
      author: author ?? "", // optional here; or you can extend json parsing
      coverUrl: coverUrl ?? '',
      description: desc ?? 'No description available.',
    );
  }
}
