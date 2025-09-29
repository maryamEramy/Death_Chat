import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MessageUi extends StatefulWidget {
  final String? message, sender;
  final bool? isMe;
  const MessageUi({Key? key, this.message, this.sender, this.isMe}) : super(key : key);

  @override
  State<MessageUi> createState() => _MessageUiState();
}

class _MessageUiState extends State<MessageUi> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'messageUi',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: widget.isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: Material(
            borderRadius: BorderRadius.only(
              topLeft: widget.isMe! ? Radius.circular(bubbleRadius) : Radius.circular(0),
              topRight: widget.isMe! ? Radius.circular(0) : Radius.circular(bubbleRadius),
              bottomLeft: Radius.circular(bubbleRadius),
              bottomRight: Radius.circular(bubbleRadius),
            ),
            color: widget.isMe! ? kSenderBoxColor :kSendButtonColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Text(
                    widget.sender!,
                    style: TextStyle(fontSize: 12, color: kChatEmailColor),
                  ),
                  SizedBox(height: 6.0),
                  // DefaultTextStyle(
                  //   style: TextStyle(
                  //     fontSize: 16.0,
                  //     color: Colors.white,
                  //   ),
                  //   child: AnimatedTextKit(
                  //     totalRepeatCount: 1,
                  //     animatedTexts: [TypewriterAnimatedText(widget.message!)],
                  //   ),
                  // ),
                  Text(
                    widget.message!,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}