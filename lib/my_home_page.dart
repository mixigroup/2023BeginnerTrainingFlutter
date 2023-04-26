import 'dart:convert';

import 'package:chat_sample/model/repository.dart';
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
  // state を変更！
  List<Repository> _repositories = [];

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
    // json から dart で扱える（Map<String, dynamic> のリスト）に変換（decode）
    final List body = json.decode(response.body);
    // リストに入ってる Map<String, dynamic>を map で１つ１つ取り出し Repository モデルに変換
    List<Repository> repositories = List<Repository>.from(
      body.map((item) => Repository.fromJson(item)),
    );
    // . でAPIのレスポンスのプロパティの候補がサジェストされるようになる✨
    debugPrint(repositories[0].name);

    // state に保存する！
    setState(() {
      _repositories = repositories;
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
      body: _repositories.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
              itemCount: _repositories.length,
              itemBuilder: ((context, index) {
                return Text(_repositories[index].name);
              }),
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
