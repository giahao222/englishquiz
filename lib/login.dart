import 'package:englishquiz/register.dart';
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
              ElevatedButton(
                onPressed: () {
                  // Xử lý đăng nhập mới
                },
                child: Text('Đăng nhập',
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
              ),
              SizedBox(height: 20.0),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('HOẶC',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
                        fit: BoxFit.cover,
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
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Don't have account? Sign up
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement (
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
