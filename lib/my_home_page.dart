import 'package:flutter/material.dart';
// http パッケージを使うために http として import
import 'package:http/http.dart' as http;

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
  String _body = '';

  // リポジトリ取得のメソッドを作るよ！
  Future<void> getRepo() async {
    // url とパスを書く
    final url = Uri.https('api.github.com', 'users/kno3a87/repos');
    // 今回は get でリポジトリ一覧取得！結果が response に入ってくる！
    final response = await http.get(
      url,
      // ヘッダー書きたいならこう！
      // ```
      // headers: {
      //   'Authorization':
      //       'Bearer <MY-TOKEN>',
      //   'X-GitHub-Api-Version': '2022-11-28',
      //   'Accept': 'application/vnd.github+json'
      // },
      // ```
    );
    // 中身を確認してみる
    debugPrint('Response status: ${response.body}');
    // state に保存する！
    setState(() {
      _body = response.body;
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
      // 画面から要素がはみ出したらスクロールできるようにしてくれるウィジェット
      body: SingleChildScrollView(
        child: Text(
          _body,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getRepo();
        },
        tooltip: 'get my repository',
        child: const Icon(Icons.add),
      ),
    );
  }
}
