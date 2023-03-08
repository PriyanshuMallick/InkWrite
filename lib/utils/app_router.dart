import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static final loggedOutRouter = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: LoginScreen()),
  });
  static final loggedInRouter = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: HomeScreen()),
  });
}
