import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: (){
              Navigator.pop(context);
              AuthService().signOutUserWithEmailAndPassword();
            },
          ),
        ],
        title: const Text('💀 Chat'),
      ),
      body: SafeArea(child: Column(
        children: [
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: TextField(
                  controller: _messageTextController,
                  decoration: kMessageTextFieldDecoration,
                )),
                TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'date' : DateTime.now().millisecondsSinceEpoch,
                        'text' : _messageTextController.text,
                        'sender' : AuthService().getCurrentUser!.email,
                      });
                    },
                child: const Icon(Icons.send,
                size: 30, color: Colors.  red),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
