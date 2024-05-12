import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu cũ',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Đổi mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu mới có khớp nhau không
    if (newPassword == confirmPassword) {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        print("Password updated successfully!");
        // Hiển thị thông báo hoặc chuyển hướng người dùng đến trang khác sau khi đổi mật khẩu thành công
      } catch (error) {
        print("Failed to update password: $error");
        // Xử lý lỗi khi đổi mật khẩu không thành công
      }
      // Gọi hàm đổi mật khẩu ở đây, bạn có thể sử dụng các phương thức của Firebase Auth hoặc API của bạn
      // Sau khi thay đổi mật khẩu thành công, bạn có thể chuyển hướng hoặc hiển thị thông báo tương ứng.
      print('Đổi mật khẩu thành công');
    } else {
      // Hiển thị thông báo lỗi nếu mật khẩu mới và xác nhận mật khẩu mới không khớp nhau
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Mật khẩu mới và xác nhận mật khẩu mới không khớp nhau. Vui lòng thử lại.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    // Cleanup controllers
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
