import 'package:book_details/book_details_screen.dart';
import 'package:dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:search/di/search_provider.dart';
import 'package:search/search_screen.dart';
import 'nav_bar_screen.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  const NavBarScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) =>  const SearchProvider());
      case '/details':
        return MaterialPageRoute(builder: (_) => const BookDetailsScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page Not Found")),
          ),
        );
    }
  }
}
