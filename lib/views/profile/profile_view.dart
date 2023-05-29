import 'package:firetrip/global/authentication/auth.dart';
import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/styles/styles.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            /// Profile picture
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/avatar.png"),
              radius: 55.0,
            ),
          ),
          const Divider(
            height: 60.0,
            color: Colors.grey,
          ),

          /// User Name
          const Text("NAME",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0)),
          const SizedBox(height: 10.0),
          Text(currentUserInfo?.name ?? "Not available",
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0)),
          const SizedBox(height: 30.0),

          /// User Phone number
          const Text("PHONE NUMBER",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0)),
          const SizedBox(height: 10.0),
          Text(currentUserInfo?.phone ?? "Not available",
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0)),
          const SizedBox(height: 30.0),

          /// User email
          Row(
            children: [
              const Icon(Icons.mail, color: blackColor),
              const SizedBox(width: 10.0),
              Text(currentUserInfo?.email ?? "Not available",
                  style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0))
            ],
          ),
          const SizedBox(height: 30.0),

          /// User address
          Row(
            children: [
              const Icon(Icons.home_filled, color: blackColor),
              const SizedBox(width: 10.0),
              Text(currentUserInfo?.address ?? "Not available",
                  style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0))
            ],
          ),
          const SizedBox(height: 30.0),

          /// Sign out button
          ElevatedButton(
            style: textButtonStyle,
            onPressed: () {
              firebaseAuth.signOut();
              Navigator.pushReplacementNamed(context, RouteNames.login);
            },
            child: const Text("Sign Out"),
          )
        ],
      ),
    );
  }
}
