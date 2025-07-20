import 'package:local_db/book.dart';

abstract class LocalDataSource {
  Future<void> saveBook(Book book);
  Future<bool> isBookSaved(Book book);
  Future<List<Book>> getAllBooks();
  Future<void> deleteBook(Book book) ;
  Future<Book?> getBookByKey(String key) ;
}
