import 'package:design_system/book_card_shimmer.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/presenatation/bloc/book_bloc.dart';
import 'package:home/presenatation/bloc/book_event.dart';
import 'package:home/presenatation/bloc/book_state.dart';
import 'package:local_db/local_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BookBloc bookBloc;

  @override
  void initState() {
    super.initState();
    bookBloc = context.read<BookBloc>();
    LocalDatabase.init().then((_) {
      bookBloc.add(LoadBooksEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      bloc: bookBloc,
      buildWhen: (_, __) => true,
      listenWhen: (_, __) => false,
      listener: (_, __) {},
      builder: (context, state) => _buildBody(context, state),
    );
  }
  Future<void> _refreshBooks() async {
      bookBloc.add(LoadBooksEvent());
  }
  Widget _buildBody(BuildContext context, BookState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          if (state is BooksLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, __) => const BookCardShimmer(),
            );
          } else if (state is BooksLoaded) {
            if (state.books.isEmpty) {
              return const Center(
                child: Text(
                  "No books found in DB",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: _refreshBooks,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.books.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(
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
                  );
                },
              ),
            );
          } else if (state is BooksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  state.message,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          } else {
            // fallback
            return const BookCardShimmer();
          }
        },
      ),
    );
  }
}
