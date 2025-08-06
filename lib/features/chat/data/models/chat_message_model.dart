import 'package:gazachat/features/chat/data/enums/message_status.dart';
import 'package:gazachat/features/chat/data/enums/message_type.dart';
import 'package:uuid/uuid.dart';

import 'package:json_annotation/json_annotation.dart';
part 'chat_message_model.g.dart';
// using uuid for id generation

@JsonSerializable()
class ChatMessage {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;

  ChatMessage({
    String? id,
    required this.text,
    required this.isSentByMe,
    DateTime? timestamp,
    this.status = MessageStatus.sending,
    this.type = MessageType.text,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
