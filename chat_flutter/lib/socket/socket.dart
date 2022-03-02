import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MySocket extends ChangeNotifier {
  late Socket socket;
  MySocket() {
   
  }
  @override
  void dispose() {
    disconnectSocket();
  }

  disconnectSocket() {
    try {
      socket.disconnect();
   
    } catch (e) {
   
    }
  }

  configSocket() async {
    disconnectSocket();
    String? token = await FlutterSecureStorage().read(key: 'token');
 
      socket = io(
          'https://chat-flutter-api.herokuapp.com/',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setQuery({'token': token})
              .build());
   
    initializeSocket();
  }

  void joinRoom(id) {
    socket.emit('joinRoom', {'id': id});
  }

  void initializeSocket() {
    socket.connect();

    socket.on('connect', (data) {
      print(socket.connected);
    });

    socket.on('disconnect', (data) {
      print('disconnect');
    });
    socket.on('error', (data) {
      print(data);
    });
    print(socket.connected);
  }
}
