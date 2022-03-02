import 'package:chat_flutter/models/room/message.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  AnimationController animationController;
  Message message;
  bool left ;

  ChatMessage(
      {Key? key, required this.message, required this.animationController, required this.left})
      : super(key: key);

  getAvatar() {
    return Container(
      child: CircleAvatar(
        child: new Text(message.user?.name[0]??'-'),
        backgroundColor: Color.fromARGB(255, 58, 52, 66),
      ),
    );
  }

  getBodyMessage() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade700),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(message.user?.name??'',
                      style: TextStyle(
                          color: Colors.deepPurple.shade100,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)))),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(message.message,
                      style: TextStyle(color: Colors.white))))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: Align(
        alignment: !left ? Alignment.centerLeft :Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 10, top: 10),
          padding: EdgeInsets.only(left: 5, bottom: 5, top: 5),
          width: width - 80,
          child: Row(
            children: [
              !left ? getAvatar(): getBodyMessage(),
              !left ? getBodyMessage() : getAvatar()
            ],
          ),
        ),
      ),
    );
  }
}
