import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/data/search_repository_impl.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/widgets/search_screen.dart';


class SearchProvider extends StatelessWidget {
  const SearchProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        SearchRepositoryImpl(apiService: context.read()),
      ),
      child: const SearchScreen(),
    );
  }
}