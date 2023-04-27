import 'package:json_annotation/json_annotation.dart';

// 以下は最初はエラーが出ますが無視して OK です！
// `flutter pub run build_runner build` を実行するとファイルが自動生成されてエラーも出なくなります
part 'answer.g.dart';

// model にするのは必要な要素（id と model だけ〜など）だけで十分ですが，今回は一応全要素を model にしています！
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

@JsonSerializable()
class Answer {
  Answer(
    this.id,
    this.object,
    this.created,
    this.model,
    this.usage,
    this.choices,
  );

  String id;
  String object;
  int created;
  String model;
  Usage usage;
  List<Choice> choices;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

// ネストしているものは explicitToJson: true で切り出し
@JsonSerializable(explicitToJson: true)
class Usage {
  Usage(this.promptTokens, this.completionTokens, this.totalTokens);

  @JsonKey(name: 'prompt_tokens')
  int promptTokens;
  @JsonKey(name: 'completion_tokens')
  int completionTokens;
  @JsonKey(name: 'total_tokens')
  int totalTokens;

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);
  Map<String, dynamic> toJson() => _$UsageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Choice {
  Choice(this.message, this.finishReason, this.index);

  Message message;
  @JsonKey(name: 'finish_reason')
  String finishReason;
  int index;

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Message {
  Message(this.role, this.content);

  String role;
  String content;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
