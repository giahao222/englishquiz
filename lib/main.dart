
import 'package:englishquiz/screens/auth/login.dart';

import 'package:englishquiz/screens/home/HomeFragment.dart';
import 'package:englishquiz/screens/home/MainScreen.dart';

import 'package:englishquiz/screens/home/MyCustomScrollBehavior.dart';

import 'package:englishquiz/screens/home/ModeLearn.dart';
import 'package:englishquiz/screens/public_topic/ChooseMode.dart';
import 'package:englishquiz/screens/public_topic/Modes.dart';
import 'package:englishquiz/screens/public_topic/PublicTopics.dart';

import 'package:englishquiz/screens/library/AddTopic.dart';
import 'package:englishquiz/screens/library/InTopic.dart';
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
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(FirebaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/add-topic', page: () => AddTopic()),
        GetPage(name: '/topic', page: () => InTopic()),
        GetPage(name: '/mode-learn', page: () => ModeLearn()),
        GetPage(name: '/admin-topics', page: () => HomeFragment()),
        GetPage(name: '/public-topics', page: () => PublicTopicsPage()),
        GetPage(name: '/choose-mode', page: () => ChooseModePage()),
        GetPage(name: '/result', page: () => ResultPage()),
        GetPage(name: '/home', page: () => MainScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}
