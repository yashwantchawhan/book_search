import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:book_details/domain/book_details_repository.dart';
import 'package:local_db/book.dart';
import 'package:local_db/local_data_source.dart';
import 'package:remote/api_service.dart';

class BookDetailsRepositoryImpl extends BookDetailsRepository {
  final ApiService apiService;
  final LocalDataSource localDataSource;

  BookDetailsRepositoryImpl({required this.apiService, required this.localDataSource});

  @override
  Future<BookDetailsDisplayModel> fetchBookDetails(String workKey, String? coverUrl, String? author) async {
    final cachedBook = await localDataSource.getBookByKey(workKey);
    if (cachedBook != null) {
      return BookDetailsDisplayModel(book: cachedBook, isSaved: true);
    }

    // If not in DB, make network call
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

    final book = Book(
      key: workKey,
      title: json['title'] ?? 'No Title',
      author: author ?? '', // optional or parse more fields if needed
      coverUrl: coverUrl ?? '',
      description: desc ?? 'No description available.',
    );

    // Save fetched book to DB
    await localDataSource.saveBook(book);

    return BookDetailsDisplayModel(book: book, isSaved: false);
  }

}
