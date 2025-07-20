import 'package:local_db/book.dart';

abstract class BookDetailsRepository {
  Future<Book> fetchBookDetails(String workKey, String? coverUrl, String? author);
}