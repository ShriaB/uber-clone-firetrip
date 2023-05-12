import 'package:firetrip/feature_home/views/home_view.dart';
import 'package:firetrip/feature_login/views/login_view.dart';
import 'package:firetrip/feature_login/views/register_view.dart';
import 'package:firetrip/common/routes/route_names.dart';
import 'package:firetrip/feature_search/views/search_places_view.dart';
import 'package:firetrip/feature_splash/views/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  /// Generates the routes
  /// Returns the Routes for respective route names
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
      case RouteNames.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterView());
      case RouteNames.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteNames.search:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchPlacesView());
      default:
        {
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(child: Text("Page not found")),
            );
          });
        }
    }
  }
}
