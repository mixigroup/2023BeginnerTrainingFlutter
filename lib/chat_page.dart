import 'package:chat_sample/bloc/chat_bloc.dart';
import 'package:chat_sample/bloc/chat_event.dart';
import 'package:chat_sample/bloc/chat_state.dart';
import 'package:chat_sample/model/message.dart';
import 'package:chat_sample/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // build の実行前に 1 度だけ実行される
  @override
  void initState() {
    super.initState();
    context
        .read<ChatBloc>() // context の上流で指定した bloc を読み取る
        .add(const ChatLoad()); // add でイベントを流す
  }

  void clearMessage() {
    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(const ChatDelete());
  }

  // 投稿作成ページを開く＆ ChatSend event を add するようまとめた
  Future<void> writeMessage() async {
    // await の後だと context が unmount されてしまう可能性があるので一度変数に入れる
    // https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
    final chatBloc = context.read<ChatBloc>();

    final String v = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PostPage(),
        fullscreenDialog: true,
      ),
    );
    // イベントを add
    chatBloc.add(ChatSend(text: v));
  }

  void showErrorDialog() {
    final chatBloc = context.read<ChatBloc>();
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
                chatBloc.add(const ChatRemoveError());
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.error != null) {
          showErrorDialog();
        }
      },
      // state が変わったら自動で UI 描画される！
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
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
              // state が保持してる messages を見る
              child: state.messages.isEmpty
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
                      itemCount: state.messages.length + 1,
                      itemBuilder: (context, index) {
                        // Hive には新しいものが先頭に保存されてく
                        // チャットアプリは最新が一番下にくるので reverse する
                        final reverseMessage = state.messages.reversed.toList();
                        // reverse してるのでローディングを一番上に追加 = 一番下に表示されるように！
                        if (index == 0) {
                          return SizedBox(
                            height: 40,
                            width: 40,
                            // Align がないとローディングが横幅いっぱい広がろうとする
                            child: Align(
                              alignment: Alignment.center,
                              child: state.loadingFlag
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
                    clearMessage();
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
                    await writeMessage();
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
        },
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
