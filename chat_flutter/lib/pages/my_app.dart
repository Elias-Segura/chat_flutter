import 'package:chat_flutter/graphql_actions/queries.dart';
import 'package:chat_flutter/pages/home.dart';
import 'package:chat_flutter/pages/login.dart';
import 'package:chat_flutter/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  static const String routeName = '/';
  MyApp({Key? key}) : super(key: key);

  isAuth(BuildContext context) {
    try {
      GraphQLProvider.of(context)
          .value
          .query(QueryOptions(
              document: userAuth, fetchPolicy: FetchPolicy.networkOnly))
          .then((result) {
        if (result.hasException) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Login()),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage()),
              (route) => false);
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    isAuth(context);
    return new Scaffold(
        body: Container(
      alignment: Alignment.center,
      height: double.infinity,
      child: new Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
