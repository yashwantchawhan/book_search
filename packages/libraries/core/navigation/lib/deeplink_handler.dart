import 'dart:async';

abstract class DeeplinkHandler {
  /// Check if the deeplink can be handled.
  FutureOr<bool> canOpenDeeplink(String deeplink);

  /// Perform navigation based on the deeplink.
  FutureOr<bool> openDeeplink(String deeplink);

  /// Return a [NavigationEntity] (you can define it in `navigation` package).
  NavigationEntity getNavigationEntity(String deeplink);
}

/// Example entity for analytics/tracking/etc.
class NavigationEntity {
  final String route;
  final Map<String, dynamic> arguments;

  const NavigationEntity({required this.route, this.arguments = const {}});
}