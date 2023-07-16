import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/message_request.dart';
import 'package:team_play/feature/home/providers/meesage_provider.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/models/chat.dart';
import 'package:team_play/feature/shared/models/messages.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String id;
  const ChatScreen({required this.id, Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UserProfile? userProfile;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initUserProfile();
    startUIUpdateTimer();
  }

  Future<void> initUserProfile() async {
    final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
    userProfile = await ref.read(getUserProfileProvider(uid!).future);
    setState(() {});
  }

  void startUIUpdateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: GestureDetector(
          onTap: () {
            final uid = ref.read(firebaseUIDProvider.notifier).getUid();
            context.go('/home/$uid');
          },
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: (userProfile != null && userProfile!.chats.isNotEmpty)
                ? buildChatList()
                : Container(),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final messageText = _messageController.text;
                    if (messageText.isEmpty) return;
                    userProfile!.chats
                        .firstWhere((chat) => chat.userId == widget.id)
                        .messages
                        .add(
                          Message(
                            sender: userProfile!.id,
                            recipient: widget.id,
                            content: messageText,
                            id: 'temp_id',
                          ),
                        );
                    _messageController.clear();
                    final mensaje = MessageRequest(
                      recipientId: widget.id,
                      message: messageText,
                    );
                    await ref.read(messageSeviceProvider(mensaje).future);
                    await initUserProfile();
                    setState(() {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChatList() {
    Chat? chatWithUser;

    for (Chat chat in userProfile!.chats) {
      if (chat.userId == widget.id) {
        chatWithUser = chat;
        break;
      }
    }

    if (chatWithUser == null) {
      chatWithUser = Chat(
        userId: widget.id,
        messages: [],
        id: '',
      );
      userProfile!.chats.add(chatWithUser);
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: chatWithUser.messages.length,
      itemBuilder: (context, index) {
        Message message = chatWithUser!.messages[index];
        bool isSentByMe = message.sender == widget.id;
        return Align(
          alignment: isSentByMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSentByMe ? Colors.grey[200] : Colors.blue[200],
            ),
            child: Text(message.content),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
