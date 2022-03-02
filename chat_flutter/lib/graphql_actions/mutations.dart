import 'package:graphql_flutter/graphql_flutter.dart';

final authenticationUser = gql("""

mutation AuthUser(\$input: authInput) {
  authUser(input: \$input) {
    token
    user {
      id
      name
      email
      picture
    }
  }
}

""");

final signUpUser = gql(
""" 
mutation addUser(\$input: UserInput) {
  addUser(input: \$input)
}
"""
);

final forgotPassword = gql(
"""
mutation forgotPasswordUser(\$email: String, \$date: String) {
  forgotPasswordUser(email: \$email, date: \$date)
}
"""

);

final changePasswordUser=gql(
"""
mutation changePasswordUser(\$password: String, \$code: String, \$email: String) {
  changePasswordUser(password: \$password, code: \$code, email: \$email)
}

"""
);