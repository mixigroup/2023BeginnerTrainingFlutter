import 'dart:async';
import 'dart:convert';

import 'package:chat_sample/model/answer.dart';
import 'package:chat_sample/model/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_sample/bloc/chat_event.dart';
import 'package:chat_sample/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ChatEvent と ChatState を継承
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final Future<Box<MessageItem>> messageBox = Hive.openBox('messages');

  ChatBloc() : super(const ChatState()) {
    // on は stream を listen するためのもの
    on<ChatSend>(_onChatSend);
    on<ChatDelete>(_onChatDelete);
    on<ChatLoad>(_onChatLoad);
    on<ChatRemoveError>(_onChatRemoveError);
  }

  // エラーを null に戻すメソッド
  Future<void> _onChatRemoveError(
    ChatRemoveError event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(error: null));
  }

  // チャットを取得するメソッド
  // 中身はほぼ ChatPage に実装していた getMessages()
  Future<void> _onChatLoad(
    ChatLoad event,
    Emitter<ChatState> emit,
  ) async {
    final box = await messageBox;
    final messages = box.values.toList();

    // emit 入れることで新しい state を stream に流せる
    // 取得した message を流すので UI 更新してね❣️
    emit(state.copyWith(messages: messages.cast<MessageItem>()));
  }

  // チャットを全削除するメソッド
  // 中身はほぼ ChatPage の clearMessage()
  Future<void> _onChatDelete(
    ChatDelete event,
    Emitter<ChatState> emit,
  ) async {
    final box = await messageBox;
    box.deleteAll(box.keys);

    emit(state.copyWith(messages: [].cast<MessageItem>()));
  }

  // チャットを送信するメソッド
  // 中身はほぼ ChatPage の postChat()
  Future<void> _onChatSend(
    ChatSend event,
    Emitter<ChatState> emit,
  ) async {
    // ローディングフラグを true に！
    emit(state.copyWith(loadingFlag: true));

    // 自分のメッセージ
    final message = MessageItem(role: 'user', content: event.text);

    // 自分のメッセージを stream に流す
    emit(state.copyWith(messages: [...state.messages, message]));
    // 自分のメッセージを box にも保存しておく
    (await messageBox).add(message);

    final token = dotenv.get('MY_TOKEN');
    var url = Uri(
      scheme: 'https',
      host: "api.openai.com",
      path: "v1/chat/completions",
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": state.messages
              .map(
                (e) => {'role': e.role, 'content': e.content},
              )
              .toList(),
          // system に追加すると面白い話し方とか指定できる！
          // ```
          // "messages": [
          //   {"role": "system", "content": "語尾に『にゃん』をつけて可愛くしゃべってください！"},
          //   ...state.messages,
          // ],
          // ```
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 30));

      final answer = Answer.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );

      // ChatGPT のメッセージ
      final botMessage = MessageItem(
        role: 'assistant',
        content: answer.choices.first.message.content,
      );
      // ChatGPT のメッセージを stream に流す
      emit(state.copyWith(messages: [...state.messages, botMessage]));
      // ChatGPT のメッセージも box に保存しておく
      (await messageBox).add(botMessage);
    } on Exception catch (e) {
      debugPrint("$e");
      emit(state.copyWith(error: e));
    } finally {
      // 最後にローディングのフラグを false にする
      emit(state.copyWith(loadingFlag: false));
    }
  }
}
