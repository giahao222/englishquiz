// Đây là một phần của mã trong trang ResetPasswordPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt lại mật khẩu'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // New Password Field
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            // Reset Password Button
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Đặt lại mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      // Passwords don't match, show error message
      _showErrorDialog("Mật khẩu không khớp", "Mật khẩu và xác nhận mật khẩu không giống nhau.");
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showErrorDialog("Lỗi", "Vui lòng đăng nhập trước khi đặt lại mật khẩu.");
        return;
      }

      await currentUser.updatePassword(newPassword);

      // Password changed successfully
      _showSuccessDialog("Đặt lại mật khẩu thành công", "Mật khẩu đã được đặt lại thành công.");
    } catch (error) {
      // Handle any errors
      _showErrorDialog("Đặt lại mật khẩu thất bại", error.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    // Show error dialog
  }

  void _showSuccessDialog(String title, String message) {
    // Show success dialog
  }
}
