import 'package:book_details/presentation/bloc/book_detail_bloc.dart';
import 'package:book_details/presentation/bloc/book_detail_event.dart';
import 'package:book_details/presentation/bloc/book_detail_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class BookDetailsScreen extends StatefulWidget {
  final String workKey; // e.g. /works/OL27479W
  final String? coverUrl; // optional cover
  final String? author;
  const BookDetailsScreen({
    super.key,
    required this.workKey,
    this.coverUrl,
    this.author
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late BookDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookDetailsBloc>();
    _bloc.add(FetchBookDetailsEvent(key: widget.workKey, coverUrl:  widget.coverUrl ?? "", author: widget.author ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookDetailsBloc, BookDetailsState>(
      bloc: _bloc,
      buildWhen: _buildWhen,
      listenWhen: _listenWhen,
      listener: _onStateChangeListener,
      builder: (context, state) => _onStateChangeBuilder(
        context,
        state,
      ),
    );

  }
  bool _listenWhen(
      BookDetailsState previous,
      BookDetailsState current,
      ) =>
      true;
  bool _buildWhen(
      BookDetailsState previous,
      BookDetailsState current,
      ) =>
      current is BookDetailsLoaded || current is BookDetailsError;

  void _onStateChangeListener(BuildContext context, BookDetailsState state) {
     if(state is DeleteBookState) {
       Navigator.of(context).pop();
     }
  }

  _onStateChangeBuilder(BuildContext context, BookDetailsState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          if (state is BookDetailsLoaded) {
            final bookDetail = state.bookDetail.book;
            final isSaved = state.bookDetail.isSaved;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.coverUrl != null) ...[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: widget.coverUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                        )),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    bookDetail.title ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: isSaved ? ElevatedButton.icon(
                      onPressed: () {
                        _bloc.add(DeleteBookEvent(book: bookDetail));
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Book'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ) : ElevatedButton.icon(
                      onPressed: () {
                        _bloc.add(SaveBookEvent(book: bookDetail));
                      },
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save Book'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About This Book',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookDetail.description ?? 'No description available.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          } else if (state is BookDetailsError) {
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

}
