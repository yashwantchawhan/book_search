import 'package:equatable/equatable.dart';
import 'package:home/domain/book_display_model.dart';
import 'package:local_db/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BookState {}

class BooksLoading extends BookState {}

class BooksLoaded extends BookState {
  final List<BookDisplayModel> books;

  const BooksLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BooksError extends BookState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object?> get props => [message];
}
