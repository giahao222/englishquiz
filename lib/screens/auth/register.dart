import 'package:englishquiz/services/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final _form = GlobalKey<FormState>();
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

    if (password == confirmPassword) {
      try {
        // Tạo tài khoản người dùng trong Authentication của Firebase
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Cập nhật displayName của người dùng
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();

        // Chuyển hướng đến trang chính sau khi tạo tài khoản thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

        print("User is successfully created!");
      } catch (error) {
        print("Failed to create user: $error");
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



  void writeData(String uid, String name, String email) async {
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'password': _passwordController.text,
      // Bạn có thể thêm các trường dữ liệu khác tại đây nếu cần
    };

    try {
      var url = "https://appenglishquiz-default-rtdb.firebaseio.com/Accounts/$uid.json";
      final response = await http.put( // Sử dụng PUT thay vì POST để cập nhật dữ liệu
        Uri.parse(url),
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        print("Data saved successfully!");
      } else {
        print("Failed to save data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error saving data: $error");
    }
  }


}

