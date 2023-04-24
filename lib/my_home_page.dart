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
  // リストを用意
  final list = ['ブラックサンダー🍫', 'メリンガータ🍨', 'カレーの恩返し🍛', '紅の豚🍷'];

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
          children: [
            const Text('久野の好きなものリスト'),
            // ListView を作ってくれるビルダー
            SizedBox(
              height: 200,
              child: ListView.builder(
                // 上で作った list の長さ分リストを作るよ！
                itemCount: list.length,
                // 今回は使わないので BuildContext は省略
                // index に番目が入る
                itemBuilder: (_, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // list の index 番目のテキストを表示
                      child: Text(list[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
