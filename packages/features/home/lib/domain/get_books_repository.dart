import 'package:local_db/book.dart';

abstract class GetBooksRepository {
  Future<List<Book>> getAllBookMarkedBooks() ;
}