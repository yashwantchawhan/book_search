import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchBooksEvent extends SearchEvent {
  final String query;
  final int page;
  final int limit;

  const FetchBooksEvent({
    required this.query,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [query, page, limit];
}