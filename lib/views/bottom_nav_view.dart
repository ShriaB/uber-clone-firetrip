import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/views/home/home_view.dart';
import 'package:firetrip/views/profile/profile_view.dart';
import 'package:firetrip/views/trips/all_trips_view.dart';
import 'package:flutter/material.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _MainViewState();
}

class _MainViewState extends State<BottomNavView> {
  /// Bottom Nav Bar
  int _currentIndex = 0;
  final screens = [
    const HomeView(),
    const AllTripsView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          iconSize: 30,
          currentIndex: _currentIndex,
          backgroundColor: primaryColor,
          selectedItemColor: whiteColor,
          unselectedItemColor: whiteColor.withOpacity(0.7),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.turn_sharp_right_sharp), label: "Trips"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ]),
      body: screens[_currentIndex],
    );
  }
}
