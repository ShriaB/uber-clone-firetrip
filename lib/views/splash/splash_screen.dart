import 'dart:async';

import 'package:firetrip/global/authentication/auth.dart';
import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/services/firebase_services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void isUserLoggedIn() {
    Timer(const Duration(seconds: 1), () async {
      if (firebaseAuth.currentUser != null) {
        /// User is logged in
        /// Get User info from database
        await UserSessionService.getCurrentOnlineUser();
        if (context.mounted) {
          FlutterNativeSplash.remove();
          Navigator.pushReplacementNamed(context, RouteNames.home);
        }
      } else {
        /// User is not logged in
        if (context.mounted) {
          FlutterNativeSplash.remove();
          Navigator.pushReplacementNamed(context, RouteNames.login);
        }
      }
    });
  }

  @override
  void initState() {
    isUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: whiteColor,
        body: Center(
            child: Text(
          "hello",
          style: TextStyle(color: whiteColor),
        )));
  }
}
