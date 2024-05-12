import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/models/Folder.dart';
import 'package:flutter/material.dart';

class FolderAdapter extends StatelessWidget {
  final BuildContext context;
  final List<Folder> mFolders;
  final int flag;

  FolderAdapter(this.context, this.mFolders, this.flag);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mFolders.length,
      itemBuilder: (context, index) {
        return _buildFolderItem(context, index);
      },
    );
  }

  Widget _buildFolderItem(BuildContext context, int index) {
    Folder folder = mFolders[index];
    return ListTile(
      title: Text(folder.nameFolder),
      subtitle: _buildTopicList(context, folder.mTopic),
    );
  }

  Widget _buildTopicList(BuildContext context, List<Topic> topics) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return _buildTopicItem(context, topics[index]);
        },
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, Topic topic) {
    return Card(
      child: Column(
        children: [
          Text(topic.name),
          Text(topic.creator),
        ],
      ),
    );
  }
}
