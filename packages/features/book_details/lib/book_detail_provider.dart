import 'package:book_details/data/book_details_repository_impl.dart';
import 'package:book_details/presentation/bloc/book_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_details_screen.dart';

class BookDetailsProvider extends StatelessWidget {
  final String? workKey;
  final String? coverUrl;
  final String? author;

  const BookDetailsProvider({
    super.key,
    required this.workKey,
    this.coverUrl,
    this.author
  });

  @override
  Widget build(BuildContext context) {
    if (workKey == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Missing workKey')),
      );
    }
    return BlocProvider(
      create: (_) => BookDetailsBloc(
        BookDetailsRepositoryImpl(apiService: context.read()),
        context.read(),
      ),
      child:  BookDetailsScreen(
        workKey: workKey!,
        coverUrl: coverUrl,
        author: author,
      ),
    );
  }
}

