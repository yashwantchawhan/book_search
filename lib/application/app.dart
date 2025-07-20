import 'dart:async';

import 'package:book_search/app_deeplink_handler.dart';
import 'package:book_search/app_router.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class BookSearchApp extends StatefulWidget {
  const BookSearchApp({super.key});

  @override
  State<BookSearchApp> createState() => _BookSearchAppState();
}

class _BookSearchAppState extends State<BookSearchApp> {
  final AppDeeplinkHandler deeplinkHandler =
  AppDeeplinkHandler(navigatorKey: AppRouter.navigatorKey);

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleInitialUri();
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        deeplinkHandler.openDeeplink(uri.path.isEmpty ? '/' : uri.path);
      }
    });
  }

  Future<void> _handleInitialUri() async {
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      deeplinkHandler.openDeeplink(initialUri.path.isEmpty ? '/' : initialUri.path);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Search',
      navigatorKey: AppRouter.navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}