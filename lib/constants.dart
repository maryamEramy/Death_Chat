import 'package:flutter/material.dart';

var kBackgroundColor = Colors.white12;
var kWhiteColor = Colors.white;
var kChatEmailColor = Colors.white54;
var kSenderBoxColor = Colors.white12;
var kSendButtonColor = Colors.blueAccent;
var kLoginColor = Colors.purple[200];
var kRegistrationColor = Colors.orangeAccent[200];

const bubbleRadius = 20.0;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(top: BorderSide(color: Colors.white60, width: 1)),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
