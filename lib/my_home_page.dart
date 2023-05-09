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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        // Column は [] の中身を縦に並べてくれる widget
        // Row で横になるよ
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              children: const [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ColoredBox(color: Colors.blue),
                ),
                SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ColoredBox(color: Colors.blue),
                ),
              ],
            ),
            Row(
              // center で真ん中寄せに
              mainAxisAlignment: MainAxisAlignment.center,
              // 応用：Row は広がる性質を持っているため子のサイズに合わせてあげることで Column の center が適用される
              // ```
              // mainAxisSize: MainAxisSize.min,
              // ```
              children: const [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: ColoredBox(color: Colors.pink),
                ),
                // 隙間
                SizedBox(width: 24),
                SizedBox(
                  height: 75,
                  width: 75,
                  child: ColoredBox(color: Colors.pink),
                ),
                SizedBox(width: 24),
                SizedBox(
                  height: 75,
                  width: 75,
                  child: ColoredBox(color: Colors.pink),
                ),
              ],
            ),
            Row(
              // end にすることで右端に並ぶ
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ColoredBox(color: Colors.green),
                ),
                SizedBox(width: 8),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ColoredBox(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
