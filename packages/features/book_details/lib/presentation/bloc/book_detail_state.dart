import 'package:local_db/book.dart';

abstract class BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final Book bookDetail;

  BookDetailsLoaded({required this.bookDetail});
}

class BookDetailsError extends BookDetailsState {
  final String message;

  BookDetailsError({required this.message});
}

class BookSavedState extends BookDetailsState {
  BookSavedState();
}

class BookSavedError extends BookDetailsState {
  final String message;

  BookSavedError({required this.message});
}
