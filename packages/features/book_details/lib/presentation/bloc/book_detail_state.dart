import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:local_db/book.dart';

abstract class BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final BookDetailsDisplayModel bookDetail;

  BookDetailsLoaded({required this.bookDetail});
}

class BookDetailsError extends BookDetailsState {
  final String message;

  BookDetailsError({required this.message});
}

class BookSavedState extends BookDetailsState {
  BookSavedState();
}

class DeleteBookState extends BookDetailsState {
  DeleteBookState();
}

class BookSavedError extends BookDetailsState {
  final String message;

  BookSavedError({required this.message});
}
