import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrip/models/user_model.dart';

///[firebaseAuth] Connection point to the Firebase app
final firebaseAuth = FirebaseAuth.instance;

/// [currentUser] Firebase user
User? currentUser;

/// [currentUserInfo] Information of the current user that is stored in the database while registration
UserModel? currentUserInfo;
