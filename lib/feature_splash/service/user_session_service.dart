import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/model/user_model.dart';

class UserSessionService {
  static Future<void> getCurrentOnlineUser() async {
    currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUser!.uid);
      final snap = await ref.get();
      if (snap.exists) {
        currentUserInfo = UserModel.fromSnapshot(snap);
      } else {
        print('No data available.');
      }
    }
  }
}
