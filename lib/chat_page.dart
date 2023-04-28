import 'package:chat_sample/post_page.dart';
import 'package:flutter/material.dart';

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
        // fullscreenDialog を true にすることで遷移方法が横ではなく下からになる
        // またヘッダー左上のアイコンが戻るボタンからバツボタンに変わる！
        fullscreenDialog: true,
      ),
    );
    // state 更新

    // バツボタンを押して戻ると pop 時に値は渡って来なくて null になってしまうので条件を追加
    if (v != null) {
      setState(() {
        text = v;
      });
    }
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
