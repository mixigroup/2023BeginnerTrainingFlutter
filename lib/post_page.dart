import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              // pop 時に値を渡せる！
              Navigator.pop(context, text);
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          maxLines: null,
          enabled: true,
          onChanged: (value) {
            text = value;
          },
        ),
      ),
    );
  }
}
