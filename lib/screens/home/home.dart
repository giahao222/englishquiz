import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:englishquiz/screens/auth/login.dart';

class HomePage extends StatelessWidget {
  final User user;
  final _creator = FirebaseAuth.instance.currentUser!.displayName;

  HomePage({Key? key, required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.email != null)  // Kiểm tra user không null và email không null
              Text(
                'Xin chào, ${_creator}!',
                style: TextStyle(fontSize: 20.0),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Logout successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print(e.toString());
    }
  }

}
