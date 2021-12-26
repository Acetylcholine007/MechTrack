import 'package:firebase_auth/firebase_auth.dart';

import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/services/DatabaseService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //MAPPING FUNCTION SECTION

  Account _userFromFirebaseUser(User user) {
    // return user != null && user.emailVerified ? Account(uid: user.uid, email: user.email) : null;
    return user != null ? Account(
      uid: user.uid,
      email: user.email,
      isAnon: user.isAnonymous,
      isEmailVerified: user.emailVerified
    ) : null;
  }

  //STREAM SECTION

  Stream<Account> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
  }

  //OPERATOR FUNCTIONS SECTION

  Future<String> signInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(result);
      return _auth.currentUser.emailVerified ? 'SUCCESS' : 'Account is not verified';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      print(result);
      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> register(AccountData accountData, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await DatabaseService.db.createAccount(accountData, user.email, user.uid);
      // user.sendEmailVerification();

      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> signOut() async {
    String result  = '';
    await _auth.signOut()
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> changePassword(String newPassword) async {
    String result  = '';
    await _auth.currentUser.updatePassword(newPassword)
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  FirebaseAuth get auth => _auth;
}