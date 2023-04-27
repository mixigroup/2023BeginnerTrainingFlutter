import 'package:chat_sample/post_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatPage extends StatefulWidget {
  // title を受け取ってるね👀
  const ChatPage({super.key, required this.title});

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String text = '';

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
        "messages": [
          {"role": "user", "content": text}
        ]
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    // map に変換
    Map<String, dynamic> answer = json.decode(utf8.decode(response.bodyBytes));

    // === response example ===
    // flutter: {
    //   id: chatcmpl-74OhlSNJnDsFFEODxJOyzSK9zCndX,
    //   object: chat.completion,
    //   created: 1681282633,
    //   model: gpt-3.5-turbo-0301,
    //   usage: {
    //     prompt_tokens: 16,
    //     completion_tokens: 135,
    //     total_tokens: 151
    //   },
    //   choices: [
    //     {
    //       message: {
    //         role: assistant,
    //         content: こんにちは！何かお手伝いできますか？
    //       },
    //       finish_reason: stop,
    //       index: 0
    //     }
    //   ]
    // }

    // response をみながら返信を state に渡す
    setState(() {
      text = answer['choices'].first["message"]["content"];
    });
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
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium,
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
