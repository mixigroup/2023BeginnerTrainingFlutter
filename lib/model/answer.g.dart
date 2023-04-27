// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      json['id'] as String,
      json['object'] as String,
      json['created'] as int,
      json['model'] as String,
      Usage.fromJson(json['usage'] as Map<String, dynamic>),
      (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'usage': instance.usage,
      'choices': instance.choices,
    };

Usage _$UsageFromJson(Map<String, dynamic> json) => Usage(
      json['prompt_tokens'] as int,
      json['completion_tokens'] as int,
      json['total_tokens'] as int,
    );

Map<String, dynamic> _$UsageToJson(Usage instance) => <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
      'total_tokens': instance.totalTokens,
    };

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      Message.fromJson(json['message'] as Map<String, dynamic>),
      json['finish_reason'] as String,
      json['index'] as int,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'message': instance.message.toJson(),
      'finish_reason': instance.finishReason,
      'index': instance.index,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['role'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };
