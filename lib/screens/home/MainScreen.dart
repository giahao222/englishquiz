import 'package:englishquiz/screens/auth/login.dart';
import 'package:englishquiz/screens/auth/profile.dart';
import 'package:englishquiz/screens/home/BottomNavbarController.dart';
import 'package:englishquiz/screens/home/Home.dart';
import 'package:englishquiz/screens/library/Library.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:englishquiz/screens/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  final TopicController _topicController = Get.put(TopicController());
  final List<Widget> _pages = [HomePage(), const LibraryPage(), ProfilePage()];
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
