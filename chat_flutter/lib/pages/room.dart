import 'dart:convert';

import 'package:chat_flutter/models/graphql/User.dart';
import 'package:chat_flutter/models/room/chatmessage.dart';
import 'package:chat_flutter/models/room/message.dart';
import 'package:chat_flutter/pages/home.dart';
import 'package:chat_flutter/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Room extends StatefulWidget {
  String roomId;

  Room({Key? key, required this.roomId}) : super(key: key);
  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> with TickerProviderStateMixin {
  User? me;

  final List<ChatMessage> messages = [];
  TextEditingController controller = new TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    getUser();
    Provider.of<MySocket>(context, listen: false).socket.on('newMessage',
        (data) {
      User user = User.deserialize(jsonDecode(jsonEncode(data['user'])));
      ChatMessage message = new ChatMessage(
          left: user.id == me?.id,
          message: new Message(message: data['message'], user: user),
          animationController: new AnimationController(
              vsync: this, duration: Duration(milliseconds: 700)));
      setState(() {
        messages.add(message);
      });

      message.animationController.forward();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getUser() async {
    String? e = await FlutterSecureStorage().read(key: 'user');
    if (e != null) {
      setState(() {
        me = User.deserialize(jsonDecode(e));
      });
    }
  }

  sendMessage() {
    Provider.of<MySocket>(context, listen: false).socket.emit(
        'sendNewMessage', {'message': controller.text, 'id': widget.roomId});
    controller.text = '';
    _scrollDown();
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeOut,
    );
  }

  // @override
  // void deactivate() {
  //   context.read<MySocket>()
  //       .socket
  //       .emit('leaveRoom', {'id': widget.roomId});
  //   // TODO: implement deactivate
  //   super.deactivate();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: new Text(widget.roomId),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context
                  .read<MySocket>()
                  .socket
                  .emit('leaveRoom', {'id': widget.roomId});
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.purple,
                    Color.fromARGB(255, 128, 65, 209),
                  ]),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: SafeArea(
              child: Column(children: [
            Flexible(
                child: ListView.builder(
              controller: _controller,
              itemBuilder: (_, int i) => messages[i],
              itemCount: messages.length,
            )),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(children: [
                Flexible(
                    child: Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    minLines: 1,
                    style: TextStyle(color: Colors.white, height: 1),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        isDense: true,
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.white38)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.purple)),
                        fillColor: Colors.grey.shade900,
                        filled: true),
                    controller: controller,
                  ),
                )),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.purple.shade300,
                    ),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        sendMessage();
                        controller.text = '';
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                )
              ]),
            )
          ])),
        ),
      ),
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
