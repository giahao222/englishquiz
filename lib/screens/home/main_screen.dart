import 'package:englishquiz/screens/home/bottom_navbar_controller.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/screens/setting/setting_page.dart';
import 'package:englishquiz/screens/translate/translate_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final User user;
  final BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  final List<Widget> _pages = [
    const HomePage(),
    const TranslatePage(),
    const SettingPage()
  ];
  MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EngQuiz'),
      ),
      body: Obx(() => _pages[bottomNavBarController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: bottomNavBarController.currentIndex.value,
          onTap: (index) {
            bottomNavBarController.changeIndex(index);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.translate),
              label: 'Dịch',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Cài đặt',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Logout successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
