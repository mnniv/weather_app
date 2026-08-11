import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/routing/Routes.dart';
import 'package:weather_app/src/Home/screen/home_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorkey =
      GlobalKey<NavigatorState>();

  static GoRouter buildRouter(String startRoute) {
    return GoRouter(
      navigatorKey: navigatorkey,
      initialLocation: startRoute,
      routes: [
        GoRoute(
          path: Routes.home,
          name: 'home',
          builder: (context, state) => HomePage(),
        ),
      ],
    );
  }
}
