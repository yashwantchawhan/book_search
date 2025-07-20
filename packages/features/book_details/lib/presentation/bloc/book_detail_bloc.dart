
import 'package:book_details/domain/book_details_repository.dart';
import 'package:book_details/presentation/bloc/book_detail_event.dart';
import 'package:book_details/presentation/bloc/book_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db/local_data_source.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final BookDetailsRepository repository;
  final LocalDataSource localDataSource;

  BookDetailsBloc(this.repository, this.localDataSource) : super(BookDetailsLoading()) {
    on<FetchBookDetailsEvent>((event, emit) async {
      emit(BookDetailsLoading());
      try {
        final bookDetails =
        await repository.fetchBookDetails(event.key,event.coverUrl, event.author);
        emit(BookDetailsLoaded(bookDetail: bookDetails));
      } catch (e) {
        emit(BookDetailsError(message: e.toString()));
      }
    });

    on<SaveBookEvent>((event, emit) async {
      emit(BookDetailsLoading());
      try {
        final bookDetails = await localDataSource.saveBook(event.book);
        emit(BookSavedState());
      } catch (e) {
        emit(BookSavedError(message: e.toString()));
      }
    });
  }
}
