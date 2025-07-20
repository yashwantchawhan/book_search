import 'package:book_search/app.dart';
import 'package:book_search/app_setup.dart';
import 'package:book_search/dependency_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupApiService(GetIt.instance);
  runApp(
    DependencyProvider(
      builder: (_) => const BookSearchApp(),
    ),
  );
}
