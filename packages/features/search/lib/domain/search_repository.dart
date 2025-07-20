import 'package:local_db/book.dart';

abstract class SearchRepository {
  Future<List<Book>> searchBook(String query,int page, int limit);
}