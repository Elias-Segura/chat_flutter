
import 'package:graphql_flutter/graphql_flutter.dart';

final userAuth = gql(
"""
query authUserContext {
  authUserContext{
    id
    name
    email
    picture
  }
}


 """
);