import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplimentation {
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplimentation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> getCurrentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
