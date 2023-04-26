import 'package:flutter/material.dart';

// こちらが　MyHomePage
// StatefulWidget を継承すると State を扱えるようになる
class MyHomePage extends StatefulWidget {
  // title を受け取ってるね👀
  const MyHomePage({super.key, required this.title});

  final String title;

  // MyHomePage で使う State を作るよ宣言
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State を継承して使う
class _MyHomePageState extends State<MyHomePage> {
  // この子が状態を持つデータ（今後 state と呼びます）
  // Tips: _ はプライベート変数を表してるよ
  int _counter = 0;
  int _counter2 = 1;

  void _increment() {
    // state は setState() 内で更新させないと再描画されないよ！
    setState(() {
      // 右下のボタンが押されたら _counter が 0 からプラスされた状態になる
      _counter++;
    });
  }

  void _twice() {
    setState(() {
      _counter2 = _counter2 * 2;
    });
  }

  // state が変わると　build 内が再レンダリングされる
  // print 文を入れてログを見てみよう
  @override
  Widget build(BuildContext context) {
    debugPrint("build の中");

    // setState は state を変更したあとに build を行わせる（dirtyフラグを立てる）メソッドなので build の中では使いません🙅‍♀️
    // ▼ NG 例
    // setState(() {
    //   _counter++;
    // });

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
              '足し算:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              '2倍されてく:',
            ),
            Text(
              '$_counter2',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _twice,
            tooltip: '3 times',
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
