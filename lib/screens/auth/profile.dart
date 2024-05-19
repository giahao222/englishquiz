import 'package:englishquiz/screens/auth/change_password.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  final String? displayName = FirebaseAuth.instance.currentUser!.displayName;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage(
                  'assets/google.jpg'), // Thay đổi đường dẫn ảnh của bạn tại đây
              // Nếu không có ảnh, bạn có thể sử dụng AssetImage('assets/flutter_logo.png') hoặc bất kỳ hình ảnh mặc định nào bạn muốn.
            ),
            SizedBox(height: 20.0),
            Text(
              displayName ?? "Unknown",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.0),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('My Library'),
              onTap: () {
                // Xử lý khi nhấp vào "My Library"
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Xử lý khi nhấp vào "Change Password"
                _navigateToChangePassword(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About App'),
              onTap: () {
                // Xử lý khi nhấp vào "About App"
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Credits'),
              onTap: () {
                // Xử lý khi nhấp vào "Credits"
              },
            ),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
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

      // Use pushAndRemoveUntil to clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }
}
