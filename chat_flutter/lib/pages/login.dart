import 'dart:convert';

import 'package:chat_flutter/graphql_actions/mutations.dart';
import 'package:chat_flutter/models/alerts/message.dart';
import 'package:chat_flutter/models/graphql/User.dart';
import 'package:chat_flutter/pages/forgotpassword.dart';
import 'package:chat_flutter/pages/my_app.dart';
import 'package:chat_flutter/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

 

class Login extends StatefulWidget {
  static const String routeName = '/login';
  bool isLoading = false;

  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = const FlutterSecureStorage();

  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  bool verifyFields() {
    if (controllerEmail.text.isEmpty || controllerPassword.text.isEmpty) {
      return false;
    }
    return true;
  }

  void changeStateLoading(bool state) {
    setState(() {
      widget.isLoading = state;
    });
  }

  goToHome(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  }

  authUser(BuildContext context) async {
    try {
      changeStateLoading(true);
      GraphQLProvider.of(context)
          .value
          .mutate(MutationOptions(document: authenticationUser, variables: {
            'input': {
              'email': controllerEmail.text.toString(),
              'password': controllerPassword.text.toString()
            }
          }))
          .then((result) async {
        if (result.hasException) {
          throw Exception(result.exception?.graphqlErrors[0].message);
        }
        await _storage.write(
            key: 'token', value: result.data?['authUser']['token']);

        await _storage.write(
            key: 'user', value: json.encode(result.data?['authUser']['user']));
        changeStateLoading(false);
        goToHome(context);
      }).catchError((error) {
        changeStateLoading(false);
        if (error.toString().contains('GraphQL Error:')) {
          MessagesAlerts.showMessageError(
              context,
              error
                  .toString()
                  .replaceAll('GraphQL Error:', '')
                  .replaceAll('Exception:', '')
                  .trim());
        } else {
      
          MessagesAlerts.showMessageError(context, 'Something went wrong');
        }
      });
    } catch (e) {
      MessagesAlerts.showMessageError(context, 'Something went wrong');
      changeStateLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.black87,
        height: height,
        width: width,
        child: SingleChildScrollView(
            child: widget.isLoading
                ? Container(
                    alignment: Alignment.center,
                    height: height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 50.0),
                        height: height * 0.30,
                        width: width * 0.60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70.0),
                          child: Image.asset(
                            'assets/chat.jpg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      TextField(
                        controller: controllerEmail,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.deepPurple.shade600)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: controllerPassword,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.deepPurple.shade600)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgotPassword()));
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10.0),
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (verifyFields()) {
                                  authUser(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('All field are required'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                    backgroundColor: Colors.black26,
                                  ));
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
                                  constraints: BoxConstraints(
                                      maxWidth: 200.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "LOGIN".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()));
                        },
                        child: Text.rich(TextSpan(
                            text: 'Don\'t have account ? ',
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                  text: 'Signup',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ])),
                      )
                    ],
                  )),
      ),
    );
  }
}
