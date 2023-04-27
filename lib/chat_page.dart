import 'package:chat_sample/model/answer.dart';
import 'package:chat_sample/post_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatPage extends StatefulWidget {
  // title を受け取ってるね👀
  const ChatPage({super.key, required this.title});

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // メッセージを溜めてく箱を準備
  late final Future<Box> messageBox = Hive.openBox('messages');

  String _text = '';
  // ローディングの表示・非表示を切り替える bool 値を追加
  bool loadingFlag = false;

  Future<void> openPostPage() async {
    // pop 時に渡ってきた値は await して取得！
    final v = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostPage(),
        fullscreenDialog: true,
      ),
    );
    // 受け取ったテキストを chatgpt に投げる！
    if (v != null) {
      await postChat(v);
    }
  }

  Future<void> postChat(String text) async {
    // ローディング開始！
    setState(() {
      loadingFlag = true;
    });

    // 準備した箱を使えるように
    final box = await messageBox;
    // 自分のメッセージ
    final message = {
      'content': text,
      'role': "user",
    };
    // 自分のメッセージを箱に保存
    box.add(message);

    final token = dotenv.get('MY_TOKEN');

    // 接続！
    var url = Uri.https(
      "api.openai.com",
      "v1/chat/completions",
    );
    final response = await http.post(
      url,
      body: json.encode({
        "model": "gpt-3.5-turbo",
        // system に追加すると面白い話し方とか指定できる！
        // ```
        // "messages": [
        //   {"role": "system", "content": "語尾に『にゃん』をつけて可愛くしゃべってください！"},
        //   ...state.messages,
        // ],
        // ```
        "messages": box.values.toList(),
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    // map に変換
    Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    // model に変換
    final answer = Answer.fromJson(body);

    // ChatGPT のメッセージ
    final botMessage = {
      'content': answer.choices.first.message.content,
      'role': 'assistant',
    };
    box.add(botMessage);

    setState(() {
      _text = answer.choices.first.message.content;
      // 回答受け取れたらローディングをやめる
      loadingFlag = false;
    });

    // .values で全ての value を取得できるので確認してみる
    debugPrint(box.values.toString());
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold は土台みたいな感じ（白紙みたいな）
    return Scaffold(
      // AppBar は上のヘッダー
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      // Center で真ん中寄せ
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            loadingFlag
                ? const CircularProgressIndicator(
                    color: Colors.orange,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await openPostPage();
        },
        tooltip: 'post',
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
