import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/common/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseAuthService {
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
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(Map userInfo) async {
    try {
      firebaseAuth
          .signInWithEmailAndPassword(
              email: userInfo["email"], password: userInfo["password"])
          .then((auth) {
        currentUser = auth.user;
      });
    } catch (e) {
      rethrow;
    }
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);