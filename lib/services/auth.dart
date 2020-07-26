import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_lessons_app/models/user.dart';
import 'package:flutter_crud_lessons_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      await _db.registerUser(user.uid, name, email);
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
