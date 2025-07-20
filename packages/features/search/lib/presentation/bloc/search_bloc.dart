import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/search_repository.dart';
import 'package:search/presentation/bloc/search_events.dart';
import 'package:search/presentation/bloc/search_states.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchLoadingState()) {
    on<FetchBooksEvent>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(
      FetchBooksEvent event, Emitter<SearchState> emit) async {
    try {
      final books =
      await repository.searchBook(event.query, event.page, event.limit);
      final isLastPage = books.length < event.limit;
      emit(SearchLoadedState(books: books, isLastPage: isLastPage));
    } catch (e) {
      emit(SearchErrorState(e.toString()));
    }
  }
}


