abstract class SearchEvent {}

class FetchBooksEvent extends SearchEvent {
  final String query;
  final int page;
  final int limit;

  FetchBooksEvent({
    required this.query,
    required this.page,
    required this.limit,
  });
}
