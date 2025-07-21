import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navigation/deeplink_handler.dart';

class AppDeeplinkHandler implements DeeplinkHandler {
  AppDeeplinkHandler({required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;
  static const List<String> _supportedPaths = [
    '/',
    '/search',
    '/details',
    '/dashboard',
  ];

  @override
  bool canOpenDeeplink(String path) {
    return _supportedPaths.contains(path);
  }

  @override
  FutureOr<bool> openDeeplink(String deeplink) {
    final uri = Uri.parse(deeplink);
    var path = uri.path;

    // Treat empty path as "/"
    if (path.isEmpty) path = '/';

    if (!canOpenDeeplink(path)) return false;

    final state = navigatorKey.currentState;
    if (state == null) return false;

    state.pushNamed(
      path,
      arguments: {
        'type': 'deeplink',
        'originalDeeplink': deeplink,
      },
    );
    return true;
  }

  @override
  NavigationEntity getNavigationEntity(String deeplink) {
    final uri = Uri.parse(deeplink);
    var path = uri.path;
    if (path.isEmpty) path = '/';
    return NavigationEntity(
      route: path,
      arguments: const {'type': 'deeplink'},
    );
  }
}
