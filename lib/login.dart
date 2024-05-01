import 'package:englishquiz/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:englishquiz/home.dart';
import 'package:englishquiz/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  // Remember Me Checkbox
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        // Update the value of _rememberMe when the checkbox state changes
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Spacer(), // Add space between the checkbox and "Quên mật khẩu" text
                  // Forgot Password
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password
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

    User? user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      // Đăng ký thành công
      // Chuyển hướng đến trang chính
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
      print("User is successfully Signed In!");
    } else {
      // Đăng ký thất bại
      print("Fail to Sign In!");
    }
  }
}
