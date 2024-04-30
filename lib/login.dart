import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                alignment: Alignment.center,
                child: FlutterLogo(
                  size: 100.0,
                ),
              ),
              SizedBox(height: 20.0),
              // Email Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              // Password Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              // Forgot Password
              GestureDetector(
                onTap: () {
                  // Chuyển hướng đến trang quên mật khẩu
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Social Logins
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý đăng nhập bằng Facebook
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/facebook.jpg',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý đăng nhập bằng Gmail
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/google.jpg',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Don't have account? Sign up
              GestureDetector(
                onTap: () {
                  // Chuyển hướng đến trang đăng ký
                },
                child: Text(
                  'Bạn chưa có tài khoản? Đăng ký ngay',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
