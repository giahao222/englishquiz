import 'package:englishquiz/screens/activity/ConnectWord.dart';
import 'package:englishquiz/screens/auth/google_sign_in.dart';
import 'package:englishquiz/screens/auth/profile.dart';
import 'package:englishquiz/screens/auth/register.dart';
import 'package:englishquiz/screens/home/MainScreen.dart';
import 'package:englishquiz/screens/home/ModeLearn.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/services/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:englishquiz/screens/auth/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  void _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        if (email != null && password != null) {
          _emailController.text = email;
          _passwordController.text = password;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo.png',
                  height: 300.0,
                  width: 400.0,
                  fit: BoxFit.cover,
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
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              // Remember Me and Forgot Password
              Row(
                children: [
                  // Remember Me
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool('rememberMe', _rememberMe);
                        });
                      });
                    },
                  ),
                  Text('Remember me'),
                  Spacer(), // Add space between the checkbox and "Quên mật khẩu" text
                  // Forgot Password
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password
                      _sendPasswordResetEmail(_emailController.text);
                    },
                    child: Text(
                      'Forgot Password?',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () {
                  final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin(context);
                },
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                label: Text(
                  'Sign In With Google',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
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
                      'Do not have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Register now',
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
      User? user = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      if (user != null) {
        // Đăng nhập thành công
        // Chuyển hướng đến trang chính
        Get.offAllNamed('/home');

        // Nếu người dùng đã chọn nhớ đăng nhập, lưu thông tin đăng nhập vào SharedPreferences
        if (_rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          prefs.setString('password', password);
        }

        print("User is successfully Signed In!");
      } else {
        // Đăng nhập thất bại do người dùng hoặc mật khẩu không đúng
        // Hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content:
                  Text('Email or password is incorrect. Please try again.'),
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
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
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

  _signInWithGooole() async{

    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);

    if(userCredential.user != null){
      Get.offAllNamed('/home');
    }
  }
}
