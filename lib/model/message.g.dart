// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageItemAdapter extends TypeAdapter<MessageItem> {
  @override
  final int typeId = 0;

  @override
  MessageItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageItem(
      content: fields[0] as String,
      role: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageItem _$MessageItemFromJson(Map<String, dynamic> json) => MessageItem(
      content: json['content'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$MessageItemToJson(MessageItem instance) =>
    <String, dynamic>{
      'content': instance.content,
      'role': instance.role,
    };
