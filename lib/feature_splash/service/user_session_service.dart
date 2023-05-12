import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/model/user_model.dart';

class UserSessionService {
  static Future<void> getCurrentOnlineUser() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userRef.once().then(
        (snap) => currentUserInfo = UserModel.fromSnapshot(snap.snapshot));
  }
}
