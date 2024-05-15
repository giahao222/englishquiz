import 'package:englishquiz/screens/activity/ConnectWord.dart';
import 'package:englishquiz/screens/auth/profile.dart';
import 'package:englishquiz/screens/auth/register.dart';
import 'package:englishquiz/screens/home/MainScreen.dart';
import 'package:englishquiz/screens/home/ModeLearn.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/services/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:englishquiz/screens/auth/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false; // Default value for the remember me checkbox

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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              // Remember Me and Forgot Password
              Row(
                children: [
                  Spacer(), // Add space between the checkbox and "Quên mật khẩu" text
                  // Forgot Password
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password
                      _sendPasswordResetEmail(_emailController.text);
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Social Logins
              ElevatedButton(
                onPressed: () {
                  _signIn(context);
                },
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Divider and Social Logins buttons...
              SizedBox(height: 20.0),
              // Don't have account? Sign up
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
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

  void _signIn(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Đăng nhập thành công
        // Chuyển hướng đến trang chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        print("User is successfully Signed In!");
      } else {
        // Đăng nhập thất bại do người dùng hoặc mật khẩu không đúng
        // Hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print("Fail to Sign In!");
      }
    } catch (e) {
      print("Error signing in: $e");
      // Xử lý lỗi khi đăng nhập
      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã xảy ra lỗi khi đăng nhập. Vui lòng thử lại sau.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  void _sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Email xác minh đã được gửi thành công
      // Thông báo cho người dùng biết rằng họ cần kiểm tra email để đặt lại mật khẩu
    } catch (e) {
      print("Error sending password reset email: $e");
      // Xử lý lỗi khi gửi email xác minh
    }
  }
}
