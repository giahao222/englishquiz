import 'package:englishquiz/screens/home/bottom_navbar_controller.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/screens/library/library.dart';
import 'package:englishquiz/screens/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final User user;
  final BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  final List<Widget> _pages = [
    const HomePage(),
    const LibraryPage(),
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
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomNavBarController.currentIndex.value,
          onTap: (index) {
            bottomNavBarController.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_rounded),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
