import 'package:gazachat/features/chat/data/models/chat_message_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_chat_model.g.dart';

@JsonSerializable()
class UserChat {
  final String username2P;
  final String uuid2P;
  final bool isFavorite;
  final bool isBlocked;
  final List<ChatMessage> messages;

  UserChat({
    required this.username2P,
    required this.uuid2P,
    this.isFavorite = false,
    this.isBlocked = false,
    this.messages = const [],
  });

  factory UserChat.fromJson(Map<String, dynamic> json) =>
      _$UserChatFromJson(json);

  Map<String, dynamic> toJson() => _$UserChatToJson(this);
  // copuWith Method
  UserChat copyWith({
    String? username2P,
    String? uuid2P,
    bool? isFavorite,
    bool? isBlocked,
    List<ChatMessage>? messages,
  }) {
    return UserChat(
      username2P: username2P ?? this.username2P,
      uuid2P: uuid2P ?? this.uuid2P,
      isFavorite: isFavorite ?? this.isFavorite,
      isBlocked: isBlocked ?? this.isBlocked,
      messages: messages ?? this.messages,
    );
  }
}
