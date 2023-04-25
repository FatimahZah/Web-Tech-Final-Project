// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late List<dynamic> _posts;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    // You can replace this with your own API endpoint
    final response = await Future.delayed(
      const Duration(seconds: 1),
      () => [
        
        {
          'email': 'jane.doe@gmail.com',
          'content': 'Lorem ipsum dolor sit amet.',
          'timestamp': '2023-04-24 09:30:00'
        },
        {
          'email': 'Amin.Ahmad@gmail.com',
          'content': 'I am coming.',
          'timestamp': '2023-04-23 15:45:00'
        },
         {
          'email': 'bob.Akua@gmail.com',
          'content': 'You delayed. Obviously.',
          'timestamp': '2023-03-23 35:45:00'
        },
         {
          'email': 'bob.smith@gmail.com',
          'content': 'Consectetur adipiscing elit.',
          'timestamp': '2023-02-23 15:35:00'
        },
         {
          'email': 'bob.smith@gmail.com',
          'content': 'Consectetur adipiscing elit.',
          'timestamp': '2023-02-23 15:4:00'
        },
         {
          'email': 'mimi.smith@gmail.com',
          'content': 'Consectetur adipiscing elit.',
          'timestamp': '2023-01-23 15:45:00'
        },
      ],
    );
    setState(() {
      _posts = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_posts == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
          backgroundColor: Colors.purple,
        ),
        body: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            final email = post['email'];
            final content = post['content'];
            final timestamp = post['timestamp'];

            return Card(
              child: ListTile(
                title: Text(email),
                subtitle: Text(content),
                trailing: Text(
                  timestamp.toString(),
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12.0,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
