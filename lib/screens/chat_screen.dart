import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_ui.dart';
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
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Image.asset('images/grim-reaper.png'),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              AuthService().signOutUserWithEmailAndPassword();
            },
          ),
        ],
        title: const Text('DeAtH ChAt'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: MessageStream(fireStore: _fireStore)),
            Container(
              decoration: kMessageContainerDecoration,
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                          'senderName':
                              AuthService().getCurrentUser!.displayName,
                        });
                        _messageTextController.clear();
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.red[700]),
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
    : _firestore = fireStore,
      super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore
              .collection('messages')
              .orderBy('date', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.red[700]),
          );
        }
        if (snapshot.hasData) {
          var messages = snapshot.data!.docs;
          List<Widget> messageUi = [];
          for (var message in messages) {
            var messageText = message.get('text');
            var senderEmail = message.get('sender');
            var senderName = message.get('senderName');
            var messageBubble = MessageUi(
              message: messageText,
              sender: senderName,
              isMe: AuthService().getCurrentUser?.email == senderEmail,
            );
            messageUi.add(messageBubble);
          }
          return ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageUi,
          );
        } else {
          return const Center(child: Text('No messages yet.'));
        }
      },
    );
  }
}
