import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:local_db/book.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_events.dart';
import 'package:search/presentation/bloc/search_states.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final PagingController<int, Book> _pagingController =
  PagingController(firstPageKey: 1);
  static const _pageSize = 20;

  late SearchBloc _bloc;
  String _currentQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<SearchBloc>();

    _pagingController.addPageRequestListener((pageKey) {
      _bloc.add(FetchBooksEvent(
        query: _currentQuery,
        page: pageKey,
        limit: _pageSize,
      ));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged(String query) {
    _currentQuery = query;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Books")),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: _onSearchQueryChanged,
            ),
          ),
          Expanded(
            child: BlocListener<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchLoadedState) {
                  final isLastPage = state.isLastPage;
                  final newItems = state.books;

                  if (isLastPage) {
                    _pagingController.appendLastPage(newItems);
                  } else {
                    final nextPageKey =
                        (_pagingController.nextPageKey ?? 1) + 1;
                    _pagingController.appendPage(newItems, nextPageKey);
                  }
                } else if (state is SearchErrorState) {
                  _pagingController.error = state.errorMessage;
                }
              },
              child: PagedListView<int, Book>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Book>(
                  itemBuilder: (context, book, index) => BookCard(
                    thumbnailUrl: book.coverUrl,
                    title: book.title,
                    author: book.author,
                    onTap: () {
                      var key = book.key;
                      var coverUrl = book.coverUrl;
                      var author = book.author;
                      Navigator.of(context).pushNamed(
                        '/details?workKey=$key&coverUrl=$coverUrl&author=$author',
                      );
                    },
                  ),
                  firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                  noItemsFoundIndicatorBuilder: (_) =>
                  const Center(child: Text('No books found')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
