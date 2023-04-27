// 継承されることを前提とした抽象（abstract）クラス
// ※ 抽象クラス単体ではインスタンス化できないよ！
abstract class ChatEvent {
  const ChatEvent();
}

// 上で作った ChatEvent を継承した具象クラス
class ChatLoad extends ChatEvent {
  const ChatLoad();
}

// こちらも具象クラス
class ChatSend extends ChatEvent {
  // なんのテキストを送るかを受け取る
  final String text;

  const ChatSend({required this.text});
}

class ChatDelete extends ChatEvent {
  const ChatDelete();
}
