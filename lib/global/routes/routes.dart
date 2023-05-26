import 'package:firetrip/views/bottom_nav_view.dart';
import 'package:firetrip/views/home/review_ride_view.dart';
import 'package:firetrip/views/home/search_places_view.dart';
import 'package:firetrip/views/login/login_view.dart';
import 'package:firetrip/views/login/register_view.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/views/splash/splash_screen.dart';
import 'package:firetrip/views/trips/rate_ride_view.dart';
import 'package:firetrip/views/trips/turn_by_turn_nav.dart';
import 'package:flutter/material.dart';

class Routes {
  /// Generates the routes
  /// Returns the Routes for respective route names
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavView());
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
      case RouteNames.navigation:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TurnByTurnNav());
      case RouteNames.reviewRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReviewRideView());
      case RouteNames.rateRide:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RateRideView());
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
