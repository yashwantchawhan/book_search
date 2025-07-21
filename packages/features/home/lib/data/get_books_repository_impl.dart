import 'package:home/domain/book_display_model.dart';
import 'package:home/domain/get_books_repository.dart';
import 'package:local_db/local_data_source.dart';

class GetBooksRepositoryImpl extends GetBooksRepository {
  final LocalDataSource localDataSource;

  GetBooksRepositoryImpl({required this.localDataSource});

  @override
  Future<List<BookDisplayModel>> getAllBookMarkedBooks() async {
    final books = await localDataSource.getAllBooks();
    return books
        .map(
          (book) => BookDisplayModel(
            url: book.coverUrl ?? '',
            title: book.title,
            author: book.author,
            key: book.key,
          ),
        )
        .toList();
  }
}
