import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController _messageTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              AuthService().signOutUserWithEmailAndPassword();
            },
          ),
        ],
        title: const Text('💀 Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: MessageStream(fireStore: _fireStore)),
            Container(
              decoration: kMessageContainerDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_messageTextController.text.trim().isNotEmpty) {
                        _fireStore.collection('messages').add({
                          'date': DateTime.now().millisecondsSinceEpoch,
                          'text': _messageTextController.text.trim(),
                          'sender': AuthService().getCurrentUser!.email,
                        });
                        _messageTextController.clear();
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key, required FirebaseFirestore fireStore})
      : _firestore = fireStore , super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        if (snapshot.hasData) {
          var messages = snapshot.data!.docs;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            var messageText = message.get('text');
            var sender = message.get('sender');
            var messageBubble = MessageBubble(
              message: messageText,
              sender: sender,
              isMe: AuthService().getCurrentUser?.email == sender,
            );
            messageBubbles.add(messageBubble);
          }
          return ListView(
            reverse: true, // جدیدترین پیام پایین‌تر باشه
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          );
        } else {
          return const Center(child: Text('No messages yet.'));
        }
      },
    );
  }
}
