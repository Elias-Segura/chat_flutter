import 'package:chat_flutter/models/graphql/User.dart';

class Message {
  User? user;
  String message;

  Message({required this.user, required this.message});

}
