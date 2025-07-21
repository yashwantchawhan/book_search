import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/get_books_repository.dart';
import 'package:home/presenatation/bloc/book_event.dart';
import 'package:home/presenatation/bloc/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksRepository getBooksRepository;

  BookBloc({required this.getBooksRepository}) : super(BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
  }

  Future<void> _onLoadBooks(
      LoadBooksEvent event, Emitter<BookState> emit) async {
    emit(BooksLoading());
    try {
      final books = await getBooksRepository.getAllBookMarkedBooks();
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BooksError(e.toString()));
    }
  }
}
