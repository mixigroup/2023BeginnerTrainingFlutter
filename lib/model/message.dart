import 'package:hive_flutter/hive_flutter.dart';

part 'message.g.dart';

// json の時と同じくモデルを作成！
@HiveType(typeId: 0)
class MessageItem extends HiveObject {
  @HiveField(0)
  String content;
  @HiveField(1)
  String role;

  MessageItem({required this.content, required this.role});
}
