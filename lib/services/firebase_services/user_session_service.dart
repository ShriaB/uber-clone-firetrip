import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/global/authentication/auth.dart';
import 'package:firetrip/models/user_model.dart';
import 'package:firetrip/provider/trip_state.dart';

class UserSessionService {
  /// Get the info of the current user like name, email, phone and address from Firebase
  /// Store it in [currentUserInfo]
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
        TripStateNotifier.getTrips();
      }
    }
  }
}
