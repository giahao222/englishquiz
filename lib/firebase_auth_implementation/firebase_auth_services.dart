

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Mật khẩu quá yếu');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Mật khẩu hơi yếu"),
              content: Text("Hơi yếu nha anh trai"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng hộp thoại
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
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