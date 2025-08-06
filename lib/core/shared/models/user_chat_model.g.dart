// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChat _$UserChatFromJson(Map<String, dynamic> json) => UserChat(
  username2P: json['username2P'] as String,
  uuid2P: json['uuid2P'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
  isBlocked: json['isBlocked'] as bool? ?? false,
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserChatToJson(UserChat instance) => <String, dynamic>{
  'username2P': instance.username2P,
  'uuid2P': instance.uuid2P,
  'isFavorite': instance.isFavorite,
  'isBlocked': instance.isBlocked,
  'messages': instance.messages,
};
