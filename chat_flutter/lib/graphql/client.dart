 
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ValueNotifier<GraphQLClient> getClient() {
  final _storage = const FlutterSecureStorage();
  final HttpLink httpLink = HttpLink(
   'https://chat-flutter-api.herokuapp.com/graphql',
  );
  
   final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ${await _storage.read(key: 'token')}',
    
  );

  final Link link =  authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
 
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
 
  return client;
}
