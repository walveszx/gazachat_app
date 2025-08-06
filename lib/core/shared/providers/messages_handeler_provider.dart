import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gazachat/core/helpers/logger_debug.dart';
import 'package:gazachat/core/shared/providers/managing_bluetooth_state_privder.dart';
import 'package:gazachat/features/chat/data/enums/message_status.dart';
import 'package:gazachat/features/chat/data/enums/message_type.dart';
import 'package:gazachat/features/chat/data/models/chat_message_model.dart';
import 'package:gazachat/features/home/providrs/user_data_provider.dart';

// Provider to handle incoming Bluetooth messages
final messageHandlerProvider = Provider<MessageHandler>((ref) {
  return MessageHandler(ref);
});

class MessageHandler {
  final Ref ref;
  StreamSubscription<Map<String, String>>? _messageSubscription;

  MessageHandler(this.ref) {
    _initializeMessageListener();
  }

  void _initializeMessageListener() {
    final bluetoothState = ref.read(nearbayStateProvider);

    if (bluetoothState.messageStream != null) {
      _messageSubscription = bluetoothState.messageStream!.listen(
        (messageData) {
          _handleIncomingMessage(messageData);
        },
        onError: (error) {
          LoggerDebug.logger.e('Error listening to messages: $error');
        },
      );
    }
  }

  void _handleIncomingMessage(Map<String, String> messageData) {
    try {
      final String senderId = messageData['senderId'] ?? '';
      final String rawMessage = messageData['message'] ?? '';

      LoggerDebug.logger.d('Processing message from $senderId: $rawMessage');

      // Parse the JSON message
      final Map<String, dynamic> messageJson = jsonDecode(rawMessage);

      // Extract message details
      final String messageId = messageJson['id'] ?? '';
      final String text = messageJson['text'] ?? '';
      final String timestampStr = messageJson['timestamp'] ?? '';
      final String typeStr = messageJson['type'] ?? 'MessageType.text';
      final String senderUsername = messageJson['senderUsername'] ?? '';

      // Parse timestamp
      DateTime timestamp;
      try {
        timestamp = DateTime.parse(timestampStr);
      } catch (e) {
        timestamp = DateTime.now();
      }

      // Parse message type
      MessageType messageType = MessageType.text;
      try {
        messageType = MessageType.values.firstWhere(
          (type) => type.toString() == typeStr,
          orElse: () => MessageType.text,
        );
      } catch (e) {
        messageType = MessageType.text;
      }

      // Create ChatMessage object
      final ChatMessage incomingMessage = ChatMessage(
        id: messageId,
        text: text,
        isSentByMe: false, // This is a received message
        timestamp: timestamp,
        status: MessageStatus.delivered,
        type: messageType,
      );

      // Add message to the appropriate chat
      // The senderUsername is the person who sent this message to us
      ref
          .read(userDataProvider.notifier)
          .addMessageToChat(senderUsername, incomingMessage);

      LoggerDebug.logger.d(
        'Added incoming message to chat with $senderUsername',
      );
    } catch (e) {
      LoggerDebug.logger.e('Error processing incoming message: $e');
    }
  }

  void dispose() {
    _messageSubscription?.cancel();
  }
}

// Provider to initialize message handling
final messageHandlerInitProvider = Provider<void>((ref) {
  final handler = ref.watch(messageHandlerProvider);

  // Clean up when provider is disposed
  ref.onDispose(() {
    handler.dispose();
  });

  return;
});

