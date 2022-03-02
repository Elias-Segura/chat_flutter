import 'dart:convert';

import 'package:chat_flutter/graphql_actions/mutations.dart';
import 'package:chat_flutter/models/alerts/message.dart';
import 'package:chat_flutter/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignUp extends StatefulWidget {
  bool isLoading = false;

  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerConfirmPassword = new TextEditingController();
  TextEditingController controllerName = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changeStateLoading(bool state) {

    setState(() {
      widget.isLoading = state;
    });
  }

  goToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  bool verifyFields() {
    if (controllerEmail.text.isEmpty ||
        controllerPassword.text.isEmpty ||
        controllerConfirmPassword.text.isEmpty ||
        controllerName.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool verifyPassword() {
    if (controllerConfirmPassword.text == controllerPassword.text) {
      return true;
    }
    return false;
  }

  _signUp(BuildContext context) {
    try {
      changeStateLoading(true);
      GraphQLProvider.of(context)
          .value
          .mutate(MutationOptions(document: signUpUser, variables: {
            'input': {
              'name': controllerName.text.toString(),
              'email': controllerEmail.text.toString(),
              'password': controllerPassword.text.toString()
            }
          }))
          .then((result) {
        if (result.hasException) {
        
          throw Exception(result.exception?.graphqlErrors[0].message);
        }
        changeStateLoading(false);
        MessagesAlerts.showMessageSuccess(context, 'User created!');
        goToLogin(context);
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
      appBar: AppBar(
        title: Text('Sign Up'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.purple,
                  Color.fromARGB(255, 128, 65, 209),
                ]),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
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
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      TextField(
                        controller: controllerName,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          suffixIcon: Icon(
                            Icons.person,
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
                      SizedBox(height: 20.0),
                      TextField(
                        controller: controllerConfirmPassword,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Confirm password',
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
                            padding: EdgeInsets.only(bottom: 10.0),
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (verifyFields()) {
                                  if (verifyPassword()) {
                                    _signUp(context);
                                  } else {
                                    MessagesAlerts.showMessageError(
                                        context, 'The passwords don\'t match!');
                                  }
                                } else {
                                  MessagesAlerts.showMessageError(
                                      context, 'All fields are required');
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
                                    "SIGN UP".toUpperCase(),
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
                    ],
                  )),
      ),
    );
  }
}
