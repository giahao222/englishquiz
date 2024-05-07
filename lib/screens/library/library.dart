import 'package:englishquiz/screens/library/MyFolder.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Row(
        children: [
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Library',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'My Folder'),
                    Tab(text: 'My Topics'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  MyFolder(),
                  MyTopics()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
