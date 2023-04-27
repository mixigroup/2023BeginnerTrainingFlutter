import 'package:chat_sample/model/answer.dart';
import 'package:chat_sample/model/message.dart';
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
  // 箱に保存されるのが Map から MessageItem になるので一度アプリを消して今まで保存してたものを消してあげる必要がある
  late final Future<Box<MessageItem>> messageBox = Hive.openBox('messages');

  // Map だったのがモデルになる
  List<MessageItem> messages = [];
  // ローディングの表示・非表示を切り替える bool 値を追加
  bool loadingFlag = false;

  // build の実行前に 1 度だけ実行される
  @override
  void initState() {
    super.initState();
    // await を使うために Future で囲う
    Future(() async {
      await getMessages();
    });
  }

  // messages の取得を切り出し
  Future<void> getMessages() async {
    final box = await messageBox;
    setState(() {
      messages = box.values.toList();
    });
  }

  Future<void> clearMessage() async {
    final box = await messageBox;
    // deleteFromDisk はディレクトリごと消してしまうので deleteAll を使う
    // ディレクトリは init で作られる
    box.deleteAll(box.keys);
    // 削除したらもう一度メッセージたちを取得＆再描画
    getMessages();
  }

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
    final message = MessageItem(role: 'user', content: text);
    // 自分のメッセージを箱に保存
    box.add(message);
    // 一旦 messages 取得することで自分のテキストを表示
    await getMessages();

    final token = dotenv.get('MY_TOKEN');

    // ChatGPT に渡すために MessageItem から map に変換
    final messages = box.values
        .map(
          (e) => {'role': e.role, 'content': e.content},
        )
        .toList();

    // 接続！
    var url = Uri.https(
      "api.openai.com",
      "v1/chat/completions",
    );
    try {
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
        "messages": messages,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      ) // 30秒経っても返答なかったら TimeoutException を投げる
          .timeout(const Duration(seconds: 30));

      // map に変換
      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      // model に変換
      final answer = Answer.fromJson(body);

    // ChatGPT のメッセージ
    final botMessage = MessageItem(
      role: 'assistant',
      content: answer.choices.first.message.content,
    );
    box.add(botMessage);

      await getMessages();
      setState(() {
        // 回答受け取れたらローディングをやめる
        loadingFlag = false;
      });

      // .values で全ての value を取得できるので確認してみる
      debugPrint(box.values.toString());
      // TimeoutException などのエラーをキャッチしたら下ブロックの処理に入る！
    } catch (e) {
      // エラーになったらローディングは一旦止める
      setState(() {
        loadingFlag = false;
      });

      debugPrint("エラー: $e");

      // await 内で context 使う時はその context が mount されたかを確認
      if (context.mounted) {
        // ダイアログを表示！
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('エラー'),
              content: const Text('しばらく時間を置いてからお試しください'),
              actions: [
                TextButton(
                  child: const Text('はい'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
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
      body: SafeArea(
        child: messages.isEmpty
            ? const Center(
                child: Text(
                  'ChatGPT に何か聞いてみよう🫶🏻',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            // separated にするとアイテムの間に何かしらウィジェットを置ける（今回は隙間開けただけだけど線引いたりもできる）
            : ListView.separated(
                // reverse にすると List の下部から表示してくれるのでチャットぽい UI になる
                reverse: true,
                padding: const EdgeInsets.only(
                  right: 14,
                  left: 14,
                  bottom: 40,
                ),
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  // Hive には新しいメッセージを先頭にしてデータが保存されていく
                  // チャットアプリでは最新のメッセージが一番下になる方がより自然な UI になるので reverse する
                  final reverseMessage = messages.reversed.toList();
                  // reverse してるのでローディングを一番上に追加 = 一番下に表示されるように！
                  if (index == 0) {
                    return SizedBox(
                      height: 40,
                      width: 40,
                      // Align がないとローディングが横幅いっぱい広がろうとする
                      child: Align(
                        alignment: Alignment.center,
                        child: loadingFlag
                            ? const CircularProgressIndicator(
                                color: Colors.orangeAccent,
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  }
                  // 保存されてるメッセージの content を取得
                  return chatText(reverseMessage[index - 1]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
              ),
      ),
      // 右下のプラスボタン（Floating Action Button と言います）
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 全削除ボタンの追加
          FloatingActionButton(
            // There are multiple heroes that share the same tag within a subtree.
            // 上記エラーが出てしまうのでボタンごとに hero tag を指定してあげる必要がある
            heroTag: "clearMessage",
            backgroundColor: Colors.red,
            onPressed: () async {
              await clearMessage();
            },
            tooltip: 'clear messages',
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: "openPostPage",
            onPressed: () async {
              await openPostPage();
            },
            tooltip: 'post',
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 長いのでチャットひとつひとつのデザインを切り出しました
  Widget chatText(MessageItem message) {
    // メッセージの投稿主が自分なのか ChatGPT なのか
    final isAssistant = message.role == 'assistant';

    return Align(
      // 自分の投稿は右寄せ，ChatGPT の投稿は左寄せに
      alignment: isAssistant ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: isAssistant
            ? const EdgeInsets.only(right: 48)
            : const EdgeInsets.only(left: 48),
        child: DecoratedBox(
          // 角丸にしたり背景色つけたりデコってる💖
          decoration: isAssistant
              ? BoxDecoration(
                  color: Colors.amber[900],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                )
              : BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              // ?? は左辺が null だったら右辺を使用する，の意味
              // 今回は message['content'] が null だったら ''（空文字）を Text として表示する
              message.content,
              style: TextStyle(
                fontSize: 20,
                color: isAssistant ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
