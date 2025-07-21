import 'package:book_details/domain/book_detail_display_model.dart';

abstract class BookDetailsRepository {
  Future<BookDetailsDisplayModel> fetchBookDetails(String workKey, String? coverUrl, String? author);
}