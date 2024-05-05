import 'package:englishquiz/services/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:englishquiz/screens/home/main_screen.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

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
              onPressed: _signUp,
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

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // User? user = await _firebaseAuthService.signUpWithEmailAndPassword(email, password);
    // if (user != null) {
    //   // Đăng ký thành công
    //   // Chuyển hướng đến trang chính
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage(user: user)),
    //   );
    //   print("User is successfully created!");
    //
    // } else {
    //   // Đăng ký thất bại
    //   print("Fail to create user! Please try again!");
    // }

    if (password == confirmPassword) {
      User? user = await _firebaseAuthService.signUpWithEmailAndPassword(email, password, context);
      if (user != null) {
        // Đăng ký thành công
        // Chuyển hướng đến trang chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(user: user)),
        );
        print("User is successfully created!");
      } else {
        // Đăng ký thất bại
        print("Fail to create user! Please try again!");
      }
    } else {
      // Hiển thị thông báo rằng mật khẩu và xác nhận mật khẩu không khớp nhau
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mật khẩu không khớp"),
            content: Text("Mật khẩu và xác nhận mật khẩu không giống nhau. Vui lòng thử lại."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng hộp thoại
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }

  }
}
