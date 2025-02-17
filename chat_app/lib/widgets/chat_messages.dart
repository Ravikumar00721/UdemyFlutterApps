import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  var isauthenticated = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatsnapShots) {
        if (chatsnapShots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatsnapShots.hasData || chatsnapShots.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Messages Found"),
          );
        }
        if (chatsnapShots.hasError) {
          return const Center(
            child: Text("Something Went Wrong"),
          );
        }

        final loadMessages = chatsnapShots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadMessages[index].data();
            final nextChatMessage = index + 1 < loadMessages.length
                ? loadMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextChatMessage?['userId'];

            final nextUserNameIsSame =
                nextMessageUserId == currentMessageUserId;

            // Ensure isMe is correctly assigned
            final bool isMe = isauthenticated!.uid == currentMessageUserId;

            if (nextUserNameIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: isMe,
              );
            } else {
              return MessageBubble.first(
                message: chatMessage['text'],
                isMe: isMe,
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
              );
            }
          },
        );
      },
    );
  }
}
