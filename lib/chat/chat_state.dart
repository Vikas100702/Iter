part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> chat;

  const ChatState(this.chat);
  @override
  List<Object> get props => [chat];
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatLoaded extends ChatState {
  const ChatLoaded(List<ChatMessage> updatedChat, {required List<ChatMessage> chat}) : super(chat);
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message}) : super([]);

  @override
  List<Object> get props => [message];
}
