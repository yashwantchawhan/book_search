import 'package:book_search/application/app.dart';
import 'package:book_search/di/app_setup.dart';
import 'package:book_search/di/dependency_provider.dart';
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
