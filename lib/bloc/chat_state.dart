import 'package:chat_sample/model/message.dart';
import 'package:equatable/equatable.dart';

// 保持したい状態（state）を書いていく

// Equatable を使用して等値比較し，同じプロパティを持つインスタンスを同一として扱う
// ※ 同じ state を受け取った場合に，hashCode が違うから異なる state か〜と無駄なビルドが走らないように！
class ChatState extends Equatable {
  final List<MessageItem> messages;
  final bool loadingFlag;
  final Exception? error;

  const ChatState({
    this.messages = const [],
    this.loadingFlag = false,
    this.error,
  });

  @override
  List<Object?> get props => [messages, loadingFlag, error];

  // 独自の copyWith メソッドを作成
  // ChatState をコピーして値を引数に更新して返す！
  ChatState copyWith({
    List<MessageItem>? messages,
    bool? loadingFlag,
    Exception? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      loadingFlag: loadingFlag ?? this.loadingFlag,
      error: error,
    );
  }
}
