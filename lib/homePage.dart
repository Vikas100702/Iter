import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iter/chat/chat_bloc.dart';

class HomePage extends StatelessWidget {
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(id: "1", firstName: "Gemini");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iter"),
        actions: [
          IconButton(
            icon: Icon(Icons.image_search),
            onPressed: () => _sendGalleryMediaChat(context),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () => _sendCameraMediaChat(context),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded) {
            return DashChat(
              inputOptions: const InputOptions(),
              messageOptions: const MessageOptions(
                  showCurrentUserAvatar: true,
                  currentUserContainerColor: Colors.blue,
                  currentUserTimeTextColor: Colors.blueGrey,
                  timeTextColor: Colors.red,
                  timeFontSize: 10,
                  showTime: true),
              currentUser: currentUser,
              onSend: (chatMessage) {
                BlocProvider.of<ChatBloc>(context).add(
                  SendMessageEvent(
                    chatMessage: chatMessage, // This provides the required ChatMessage
                    geminiUser: geminiUser, // This provides the required GeminiUser
                  ),
                );
              },
              messages: state.chat,
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _sendGalleryMediaChat(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      BlocProvider.of<ChatBloc>(context).add(
        SendMediaChatEvent(
          messageText: "Describe the given image.",
          filePath: file.path,
          currentUser: currentUser,
          geminiUser: geminiUser,
        ),
      );
    }
  }

  void _sendCameraMediaChat(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      BlocProvider.of<ChatBloc>(context).add(
        SendMediaChatEvent(
          messageText: "Describe the image.",
          filePath: file.path,
          currentUser: currentUser,
          geminiUser: geminiUser,
        ),
      );
    }
  }
}
