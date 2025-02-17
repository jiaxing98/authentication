import 'package:authentication/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.onboarding,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboarding,
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      builder: (context, state) {
        final username = state.uri.queryParameters["username"];
        return HomePage(username: username!);
      },
    ),
  ],
);

abstract final class Routes {
  static const String home = "/";
  static const String onboarding = "/onboarding";
}
