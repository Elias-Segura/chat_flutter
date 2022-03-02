import 'package:chat_flutter/graphql/client.dart';
import 'package:chat_flutter/pages/my_app.dart';
import 'package:chat_flutter/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await initHiveForFlutter();

  runApp(MaterialApp(
    home: MultiProvider(
      providers: [ChangeNotifierProvider(create:  (context) => new MySocket() )],
      child: GraphQLProvider(
        client: getClient(),
        child: MaterialApp(
          home: MyApp(),
        ),
      ),
    ),
  ));
}
