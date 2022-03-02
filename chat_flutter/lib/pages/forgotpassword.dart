import 'package:chat_flutter/graphql_actions/mutations.dart';
import 'package:chat_flutter/models/alerts/message.dart';
import 'package:chat_flutter/pages/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ForgotPassword extends StatefulWidget {
  bool isLoading = false;
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController controllerEmail = new TextEditingController();

  bool verifyFields() {
    if (controllerEmail.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void changeStateLoading(bool state) {
    setState(() {
      widget.isLoading = state;
    });
  }

  _forgotPassword(BuildContext context) {
    try {
      changeStateLoading(true);
      GraphQLProvider.of(context)
          .value
          .mutate(MutationOptions(document: forgotPassword, variables: {
            'email': controllerEmail.text.toString(),
            'date': DateTime.now().toString()
          }))
          .then((result) {
        if (result.hasException) {
       
          throw Exception(result.exception?.graphqlErrors[0].message);
        }
        changeStateLoading(false);
        MessagesAlerts.showMessageSuccess(context, 'Email sended!');
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
          title: Text('Forgot Password'),
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
          )),
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
                        child: Text('Forgot Password',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              child: Text(
                                'Change Password?',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ChangePassword()));
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10.0),
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (verifyFields()) {
                                  _forgotPassword(context);
                                } else {
                                  MessagesAlerts.showMessageError(
                                      context, 'All fields are required!');
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
                                    "SEND".toUpperCase(),
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
                      )
                    ],
                  )),
      ),
    );
  }
}
