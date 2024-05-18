import 'package:englishquiz/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Finish extends StatelessWidget {
  Finish({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Finish', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Lottie.network(
                  'https://lottie.host/b7292b51-1d94-4385-be08-dbd2e528e048/LTFxvyA25Z.json'),
            ),
            Center(
              child: Text(
                'Congratulations! You have finished the flashcard mode!',
                style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFFC2185B),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/home');
                Get.toNamed('/admin-topics');
              },
              child: const Text('OK',
                  style: TextStyle(fontSize: 20, color: Color(0xFFC2185B))),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFFCE4EC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
