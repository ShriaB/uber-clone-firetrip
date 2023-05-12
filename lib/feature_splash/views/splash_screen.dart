import 'dart:async';

import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/common/routes/route_names.dart';
import 'package:firetrip/feature_splash/service/user_session_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void isUserLoggedIn() {
    Timer(Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        await UserSessionService.getCurrentOnlineUser();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        }
      } else {
        if (context.mounted) {
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
      body: Center(
          child: Text(
        "FireTrip",
        style: TextStyle(
            color: blackColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      )),
    );
  }
}
