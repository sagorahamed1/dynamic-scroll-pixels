import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ID লিস্ট
    final List<String> notificationIds = List.generate(50, (index) => 'id_$index');

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: notificationIds.length,
        itemBuilder: (context, index) {
          final id = notificationIds[index];
          return ListTile(
            title: Text("Notification $id"),
            onTap: () {
              // PostScreen-এ নেভিগেট এবং ID পাঠানো
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(postId: id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PostScreen extends StatefulWidget {
  final String postId;

  const PostScreen({super.key, required this.postId});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToPost(widget.postId);
    });
  }

  void _scrollToPost(String postId) {
    // নির্দিষ্ট ID এর ইনডেক্স খুঁজে বের করা
    final index = _getIndexFromId(postId);
    if (index != null) {
      final position = index * 116.0; // প্রতিটি আইটেমের উচ্চতা
      _scrollController.animateTo(
        position,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  int? _getIndexFromId(String postId) {
    final List<String> postIds = List.generate(50, (index) => 'id_$index');
    return postIds.indexOf(postId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> postIds = List.generate(50, (index) => 'id_$index');

    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: postIds.length,
        itemBuilder: (context, index) {
          final id = postIds[index];
          return Container(
            height: 100,
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            color: id == widget.postId ? Colors.amber : Colors.white,
            child: Text("Post $id"),
          );
        },
      ),
    );
  }
}
