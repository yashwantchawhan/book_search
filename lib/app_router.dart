import 'package:flutter/material.dart';
import 'package:home/home_screen.dart';
import 'package:search/search_screen.dart';
import 'package:book_details/book_details_screen.dart';


class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/details':
        return MaterialPageRoute(builder: (_) => const BookDetailsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page Not Found")),
          ),
        );
    }
  }
}

