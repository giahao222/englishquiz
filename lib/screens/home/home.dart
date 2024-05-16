import 'dart:ui';

import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/home/HomeFragment.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 260.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Image.network(
                  'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed('/admin-topics'),
                  child: const SizedBox(
                    height: 300.0,
                    width: double.infinity,
                    child: Card(
                      color: Color(0xFFE3F2FD),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 100.0,
                              color: Color(0xFF1E88E5),
                            ),
                            SizedBox(height: 50.0),
                            Text(
                              'English Quiz for Learners',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                            Text(
                              'Contains a lot of topics for you to learn and practice English',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => Get.toNamed('/public-topics'),
                  child: SizedBox(
                    height: 300.0,
                    width: double.infinity,
                    child: Card(
                      color: Color(0xFFF3E5F5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.public_rounded,
                              size: 100.0,
                              color: Color(0xFF8E24AA),
                            ),
                            SizedBox(height: 50.0),
                            Text(
                              'Public Topics',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8E24AA),
                              ),
                            ),
                            Text(
                              'Explore and learn from public topics',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF8E24AA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeFragment(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
