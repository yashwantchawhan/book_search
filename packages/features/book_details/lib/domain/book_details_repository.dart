import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:local_db/book.dart';

abstract class BookDetailsRepository {
  Future<BookDetailsDisplayModel> fetchBookDetails(String workKey, String? coverUrl, String? author);
}