import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/global/authentication/auth.dart';
import 'package:firetrip/services/firebase_services/user_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationService {
  /// Takes the information entered by user during registration
  /// Creates an user with email and password in Firebase and stores the user in [currentUser]
  /// Adds the user information in realtime database of Firebase
  Future<void> register(Map userInfo) async {
    try {
      firebaseAuth
          .createUserWithEmailAndPassword(
              email: userInfo["email"], password: userInfo["password"])
          .then((auth) {
        currentUser = auth.user;
        if (currentUser != null) {
          userInfo["id"] = currentUser?.uid;
          userInfo.remove("password");

          DatabaseReference userDbRef =
              FirebaseDatabase.instance.ref().child("users");
          userDbRef.child(currentUser!.uid).set(userInfo);
          UserSessionService.getCurrentOnlineUser();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Takes the email and password user has entered during login
  /// Authenticates the user with firebase and stores the user in [currentUser]
  /// Gets the user information from realtime database in Firebase
  Future<void> login(Map userInfo) async {
    try {
      final auth = await firebaseAuth.signInWithEmailAndPassword(
          email: userInfo["email"], password: userInfo["password"]);
      currentUser = auth.user;
      UserSessionService.getCurrentOnlineUser();
    } catch (e) {
      rethrow;
    }
  }
}

final firebaseAuthServiceProvider = Provider<AuthenticationService>(
  (ref) => AuthenticationService(),
);
