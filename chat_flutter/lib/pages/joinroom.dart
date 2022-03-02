import 'package:chat_flutter/models/alerts/message.dart';
import 'package:chat_flutter/pages/room.dart';
import 'package:chat_flutter/pages/home.dart';
import 'package:chat_flutter/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinRoom extends StatefulWidget {
  static const String routeName = '/joinroom';
  JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MySocket>().socket.on('responseJoinRoom', (data) {
      if (data['founded']) {
        MessagesAlerts.showMessageSuccess(context, 'Succesfully joined!');
        goToRoom(context, controller.text);
      } else {
        MessagesAlerts.showMessageError(context, 'Not found room!');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  goToRoom(BuildContext context, String roomId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Room(roomId: roomId)),
    );
  }

  void join(BuildContext context) {
    context.read<MySocket>().socket.emit('joinRoom', {'id': controller.text});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                    (route) => false)),
            title: Text('Join Room'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black,
                      Color.fromARGB(255, 128, 65, 209),
                    ]),
              ),
            ),
          ),
          body: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              color: Colors.black87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          hintText: 'Code Room',
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[700]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          join(context);
                        } else {
                          MessagesAlerts.showMessageError(
                              context, 'All fields are required!');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 128, 65, 209),
                                Color.fromARGB(255, 136, 128, 192)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "GO TO ROOM".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (route) => false);

          return false;
        });
  }
}
