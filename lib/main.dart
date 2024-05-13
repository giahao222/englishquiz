import 'package:englishquiz/screens/auth/login.dart';
import 'package:englishquiz/screens/home/Home.dart';
import 'package:englishquiz/screens/home/MainScreen.dart';
import 'package:englishquiz/screens/library/AddTopic.dart';
import 'package:englishquiz/screens/library/InTopic.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(FirebaseService());
  Get.put(TopicController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/add-topic', page: () => AddTopic()),
        GetPage(name: '/topic', page: () => InTopic()),
        GetPage(name: '/home', page: () => MainScreen()),
      ],
    );
  }
}
