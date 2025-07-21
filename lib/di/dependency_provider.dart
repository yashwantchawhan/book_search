import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:local_db/local_data_source.dart';
import 'package:local_db/local_data_source_impl.dart';
import 'package:provider/provider.dart';
import 'package:remote/api_service.dart';

class DependencyProvider extends StatelessWidget {
  const DependencyProvider({
    super.key,
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => _getIt<ApiService>()),
        Provider<LocalDataSource>(
          create: (_) => LocalDataSourceImpl(),
        ),
      ],
      builder: (context, _) => builder(context),
    );
  }
}

final _getIt = GetIt.instance;
