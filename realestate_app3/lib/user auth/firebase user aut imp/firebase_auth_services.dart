import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _updateDisplayName(username);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.message}');
      }
      return null;
    }
  }

Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      // Do not show toast here, return the error message
      return Future.error('Invalid email or password.');
    } else {
      // Do not show toast here, return the error message
      return Future.error('An error occurred: ${e.message}');
    }
  }
}


  Future<void> _updateDisplayName(String username) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(username);
    }
  }

  void showToast({required String message}) {
    Fluttertoast.showToast(msg: message);
  }
}
