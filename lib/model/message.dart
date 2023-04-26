import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

// json の時と同じくモデルを作成！
@HiveType(typeId: 0)
// API に渡すために json に戻す必要があるので追加して generate
@JsonSerializable()
class MessageItem extends HiveObject {
  @HiveField(0)
  String content;
  @HiveField(1)
  String role;

  MessageItem({required this.content, required this.role});

  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);
  Map<String, dynamic> toJson() => _$MessageItemToJson(this);
}
