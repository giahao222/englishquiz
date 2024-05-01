

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Mật khẩu quá yếu');
      } else if (e.code == 'email-already-in-use') {
        print('Email đã được sử dụng');
      }
    } catch (e) {
      print(e);
    }
  }


  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,

      );
      return userCredential.user;
    } catch (e) {
      print("something went wrong");
    } catch (e) {
      print(e);
    }
  }


}