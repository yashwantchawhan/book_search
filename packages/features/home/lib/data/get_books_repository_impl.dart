import 'package:home/domain/get_books_repository.dart';
import 'package:local_db/book.dart';
import 'package:local_db/local_data_source.dart';

class GetBooksRepositoryImpl extends GetBooksRepository {
  final LocalDataSource localDataSource;
  GetBooksRepositoryImpl({required this.localDataSource});
  @override
  Future<List<Book>> getAllBookMarkedBooks() async {
   return await localDataSource.getAllBooks();
  }

}