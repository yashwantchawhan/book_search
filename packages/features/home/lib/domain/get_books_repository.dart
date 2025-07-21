import 'package:home/domain/book_display_model.dart';

abstract class GetBooksRepository {
  Future<List<BookDisplayModel>> getAllBookMarkedBooks() ;
}