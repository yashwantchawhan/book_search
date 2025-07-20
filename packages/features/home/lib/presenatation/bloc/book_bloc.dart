import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db/local_data_source.dart';
import 'package:home/presenatation/bloc/book_event.dart';
import 'package:home/presenatation/bloc/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final LocalDataSource localDataSource;

  BookBloc({required this.localDataSource}) : super(BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
  }

  Future<void> _onLoadBooks(
      LoadBooksEvent event, Emitter<BookState> emit) async {
    emit(BooksLoading());
    try {
      final books = await localDataSource.getAllBooks();
      print('📚 Loaded ${books.length} books from DB');
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BooksError(e.toString()));
    }
  }
}
