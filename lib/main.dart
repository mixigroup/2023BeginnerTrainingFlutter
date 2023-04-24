import 'package:chat_sample/first_page.dart';
import 'package:flutter/material.dart';

// 中枢！main.dart の main() が最初に呼ばれる
void main() {
  // 下の MyApp を run するよ〜
  runApp(const MyApp());
}

// こちらが MyApp
// Widget を使うよってことで Widget を extend したクラスを作る
// StatelessWidget に関しては後で説明するよ！
class MyApp extends StatelessWidget {
  // コンストラクタ
  // クラスが作られたときにクラス内で使う変数を初期化するためのもの
  // 今回は変数がないのでデフォルトの Key のみ突っ込まれてる
  // Key, super の説明は今回は省略
  const MyApp({super.key});

  // もしクラスに変数があったらこんな感じでコンストラクタを書くよ
  // ```
  // const MyApp({Key? key, required this.hoge}) : super(key: key);
  // final String hoge;
  // ```
  // 上の main() で `MyApp(hoge: "ほげりんちょ")` みたいに渡してあげると hoge には『ほげりんちょ』が代入される

  // MaterialApp を作って返して表示させるよ！
  // MaterialApp は Flutter アプリケーションの全体を管理するもので，全体のデザイン `theme: ` や
  // 画面遷移をする場合の状態監視，最初に表示させるページ `home: ` を指定しているよ
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // OS のテーマ設定に合わせて変更できる
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 最初に表示させるページをは下の MyHomePage
      // 引数として title 渡してる（無くてもいいよ）
      home: const FirstPage(),
    );
  }
}
