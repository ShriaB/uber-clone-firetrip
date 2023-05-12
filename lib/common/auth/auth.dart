import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrip/common/model/user_model.dart';

final firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? currentUserInfo;
