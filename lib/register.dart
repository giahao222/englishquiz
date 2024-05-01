import 'package:englishquiz/login.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo hoặc Tiêu đề
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: FlutterLogo(
                size: 100.0, // Kích thước của logo
              ),
            ),
            // TextField cho Tên
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            // TextField cho Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            // TextField cho Mật khẩu
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            // TextField cho Xác nhận mật khẩu
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            // Nút Đăng ký
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng ký
              },
              child: Text('Đăng ký'),
            ),
            SizedBox(height: 20.0),
            // Chuyển hướng đến trang Đăng nhập
            GestureDetector(
              onTap: () {
                // Xử lý khi người dùng nhấp vào "Đăng nhập"
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold, // In đậm để nổi bật
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cleanup controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
