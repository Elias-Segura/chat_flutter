import 'package:chat_flutter/pages/createroom.dart';
import 'package:chat_flutter/pages/joinroom.dart';
import 'package:chat_flutter/pages/login.dart';
import 'package:chat_flutter/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  static const String routeName = '/home';
  MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = new TextEditingController();
 
  @override
  void didChangeDependencies() {
    initSocket();
   
    super.didChangeDependencies();
  }

  initSocket() async {
    await context.read<MySocket>().configSocket();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          await FlutterSecureStorage().write(key: 'token', value: '');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          );
        },
        backgroundColor: Colors.black45,
      ),
      body: new Container(
        color: Colors.black87,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => JoinRoom()),
                    );
                    ;
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
                        "JOIN ROOM".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateRoom()),
                    );
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
                        "CREATE CHATROOM".toUpperCase(),
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
    );
  }
}
