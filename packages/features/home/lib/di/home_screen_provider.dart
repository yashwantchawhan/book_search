import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/data/get_books_repository_impl.dart';
import 'package:home/home.dart';
import 'package:home/presenatation/bloc/book_bloc.dart';

class HomeScreenProvider extends StatelessWidget {
  const HomeScreenProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(
        getBooksRepository: GetBooksRepositoryImpl(
          localDataSource: context.read(),
        ),
      ),
      child: const HomeScreen(),
    );
  }
}
