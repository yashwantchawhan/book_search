import 'package:local_db/book.dart';
import 'package:local_db/local_data_source.dart';
import 'package:local_db/local_database.dart';

class LocalDataSourceImpl extends LocalDataSource {
  @override
  Future<void> deleteBook(Book book) async {
    return await LocalDatabase.deleteBook(book);
  }

  @override
  Future<List<Book>> getAllBooks() async {
    return await LocalDatabase.getAllBooks();
  }

  @override
  Future<bool> isBookSaved(Book book) async {
    return await LocalDatabase.isBookSaved(book);
  }

  @override
  Future<void> saveBook(Book book) async {
    return await LocalDatabase.saveBook(book);
  }
}
