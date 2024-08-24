part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final ChatMessage chatMessage;
  final ChatUser geminiUser;

  const SendMessageEvent({required this.chatMessage, required this.geminiUser});

  @override
  List<Object> get props => [chatMessage, geminiUser];
}

class SendMediaChatEvent extends ChatEvent {
  final String messageText;
  final String filePath;
  final ChatUser currentUser;
  final ChatUser geminiUser;

  const SendMediaChatEvent(
      {required this.messageText, required this.filePath, required this.currentUser, required this.geminiUser});

  @override
  List<Object> get props => [messageText, filePath, currentUser, geminiUser];
}
