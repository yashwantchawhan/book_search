import 'package:local_db/book.dart';

abstract class SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<Book> books;
  final bool isLastPage;

  SearchLoadedState({required this.books, required this.isLastPage});
}

class SearchErrorState extends SearchState {
  final String errorMessage;

  SearchErrorState(this.errorMessage);
}