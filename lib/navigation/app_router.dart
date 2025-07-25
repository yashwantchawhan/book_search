import 'package:book_details/di/book_detail_provider.dart';
import 'package:dashboard/di/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:home/di/home_screen_provider.dart';
import 'package:search/di/search_provider.dart';

import 'nav_bar_screen.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.tryParse(settings.name ?? '');

    if (uri != null && uri.path == '/details') {
      final workKey = uri.queryParameters['workKey'];
      final coverUrl = uri.queryParameters['coverUrl'];
      final author = uri.queryParameters['author'];
      return MaterialPageRoute(
        builder: (_) => BookDetailsProvider(
          workKey: workKey,
          coverUrl: coverUrl,
          author: author,
        ),
      );
    }
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  const NavBarScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) =>  const SearchProvider());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardProvider());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreenProvider());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page Not Found")),
          ),
        );
    }
  }
}
