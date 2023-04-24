import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Second"),
            IconButton(
              onPressed: () {
                // 戻るときは push じゃなく pop
                Navigator.pop(context);
                // これだとさらに追加されちゃう！
                // ```
                // Navigator.pushNamed(context, "/");
                // ```
              },
              icon: const Icon(Icons.arrow_back),
            )
          ],
        ),
      ),
    );
  }
}
