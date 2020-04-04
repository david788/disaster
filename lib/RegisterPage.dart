//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//flutter
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//pages
import 'package:chap/Login.dart';


//logic part
class RegisterPage extends StatefulWidget {
 
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //loading bar
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

//password eye visibility
  bool isHidden = true;
  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  final formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var cpassword = TextEditingController();
  var phonenumber = TextEditingController();

  //validate function for inputs
  void validateForm() {
    if (formKey.currentState.validate()) {
      signUpUser();
    }
  }

//function to send verification code to emails
  Future<void> sendEmailVerification(String email) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

//signUpUser function for registering new users to the app
// and store their details to firestore
//and send them email verification code
  Future signUpUser() async {
    toggleLoading();
    try {
      print(email.toString());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print("Success");
      var user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance.collection('users').document(user.uid).setData({
        'contact': phonenumber.text,
        'email': email.text,
        'usertype': 'client'
      }).whenComplete(() {
        Fluttertoast.showToast(
          msg: 'Registered successfully',
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent,
        );
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
      await sendEmailVerification(email.text);
      print("code sent");
      toggleLoading();
      createAlertDialog(context);
    } catch (e) {
      toggleLoading();
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueAccent,
      );
    }
  }

//aler dialog to alert the user that the link has been sent to their email
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Congratulations !!'),
            content: Text(
                'Email verification code has been sent to your email. Please  verify your email to continue'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: !loading
            ? Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset("images/image_01.png"),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 60),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset("images/logo.png"),
                              Text(
                                'Ripoti Chapchap',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Form(
                            key: formKey,
                            child: Container(
                              width: double.infinity,
                              height: 520,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, 15.0),
                                    blurRadius: 15.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        hintText: "Enter a Valid Email Address",
                                        labelText: "email",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "please enter email";
                                        }
                                        if (!value.contains('@')) {
                                          return "email is badly formated";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: phonenumber,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                        hintText: "Enter phone number",
                                        labelText: "phone number",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "please enter phone number";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      obscureText: isHidden,
                                      controller: password,
                                      maxLength: 8,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.enhanced_encryption),
                                        suffixIcon: isHidden
                                            ? IconButton(
                                                icon: Icon(Icons.visibility),
                                                onPressed: () {
                                                  toggleVisibility();
                                                })
                                            : IconButton(
                                                icon:
                                                    Icon(Icons.visibility_off),
                                                onPressed: () {
                                                  toggleVisibility();
                                                }),
                                        hintText: "Enter Password",
                                        labelText: "password",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "please enter password";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      obscureText: isHidden,
                                      controller: cpassword,
                                      maxLength: 8,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.enhanced_encryption),
                                        suffixIcon: isHidden
                                            ? IconButton(
                                                icon: Icon(Icons.visibility),
                                                onPressed: () {
                                                  toggleVisibility();
                                                })
                                            : IconButton(
                                                icon:
                                                    Icon(Icons.visibility_off),
                                                onPressed: () {
                                                  toggleVisibility();
                                                }),
                                        hintText: "Enter Password",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "please enter password";
                                        }
                                        if (value != password.text) {
                                          return "passwords do not match";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Clear",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              email.text = "";
                                              phonenumber.text = "";
                                              password.text = "";
                                              cpassword.text = "";
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CupertinoButton(
                            color: CupertinoTheme.of(context).primaryColor,
                            child: Text(
                              'SignUp',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              validateForm();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              ));
  }
}
