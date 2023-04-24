import 'package:chat_sample/second_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("First"),
            IconButton(
              onPressed: () {
                // 画面遷移には Navigator を使う
                Navigator.push(
                  context,
                  // route（道）を作ってあげる
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
