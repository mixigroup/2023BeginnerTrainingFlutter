import 'package:flutter/material.dart';

// こちらが　MyHomePage
// StatefulWidget に関しても後で説明するよ！！！！！
class MyHomePage extends StatefulWidget {
  // title を受け取ってるね👀
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tmpText = '';
  String showText = '';

  @override
  Widget build(BuildContext context) {
    // Scaffold は土台みたいな感じ（白紙みたいな）
    return Scaffold(
      // AppBar は上のヘッダー
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Center で真ん中寄せ
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              // 打った文字が value に入ってくる
              onChanged: (value) {
                tmpText = value;
              },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  showText = tmpText;
                });
              },
              icon: const Icon(Icons.arrow_downward),
            ),
            // 表示
            Text(showText),
          ],
        ),
      ),
    );
  }
}
