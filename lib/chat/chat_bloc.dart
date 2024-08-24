import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'dart:io';

import '../utils/constants.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendMediaChatEvent>(_onSendMediaChat);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final List<ChatMessage> updatedChat = [event.chatMessage, ...state.chat];
    emit(ChatLoaded(updatedChat, chat: const []));

    try {
      final response = await _sendRequest(event.chatMessage.text);
      if (response != null) {
        ChatMessage chatMessage = ChatMessage(
          user: event.geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        final newChat = [chatMessage, ...updatedChat];
        emit(ChatLoaded(newChat, chat: const []));
      }
    } catch (e) {
      emit(ChatError(message: "Error: $e"));
    }
  }

  Future<void> _onSendMediaChat(SendMediaChatEvent event, Emitter<ChatState> emit) async {
    final chatMessage = ChatMessage(
      user: event.currentUser,
      createdAt: DateTime.now(),
      text: event.messageText,
      medias: [
        ChatMedia(
          url: event.filePath,
          fileName: "",
          type: MediaType.image,
        )
      ],
    );
    final List<ChatMessage> updatedChat = [chatMessage, ...state.chat];
    emit(ChatLoaded(updatedChat, chat: const []));

    try {
      List<Uint8List>? images = [File(event.filePath).readAsBytesSync()];
      final response = await _sendRequest(event.messageText, images: images);
      if (response != null) {
        ChatMessage chatMessage = ChatMessage(
          user: event.geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        final newChat = [chatMessage, ...updatedChat];
        emit(ChatLoaded(newChat, chat: const []));
      }
    } catch (e) {
      emit(ChatError(message: "Error: $e"));
    }
  }

  Future<String?> _sendRequest(String text, {List<Uint8List>? images}) async {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'prompt': text,
      if (images != null) 'images': images.map((img) => base64Encode(img)).toList(),
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates']?[0]['output']?.toString();
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
