import 'package:flutter/material.dart';

class MessagesAlerts{
  static showMessageError(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text( message, style:TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.black,
              onPressed: () {},
            ),
            backgroundColor: Colors.red[400],
          ));
  }
  static showMessageSuccess(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text( message, style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {},
            ),
            backgroundColor: Colors.green,
          ));
  }
}