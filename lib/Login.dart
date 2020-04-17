//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//pages
import 'package:chap/Admin/AdminHomePage.dart';
import 'package:chap/PasswordResetPage.dart';
import 'package:chap/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

//logic part
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isUserVerified;

  //loading spinner
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

//vissibility of the obscure text
  bool isHidden = true;
  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  final formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();

  bool isLoggedIn = false;
  String useremail = '';

//the shared prefs that will store a value to maintain auth state
  Future<Null> storeLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('useremail', email.text);

    setState(() {
      useremail = email.text;
      isLoggedIn = true;
    });
  }

  //login function to log user and
  //verify whether the user account is verified or not
  //then store a value to shared prefs
  Future<void> loginUser(var email, var password) async {
    toggleLoading();
    try {
      await userVerification();
      var user = await FirebaseAuth.instance.currentUser();
      if (_isUserVerified == true) {
        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get()
            .then((DocumentSnapshot ds) {
          if (ds['usertype'].toString() == "client") {
            print(ds.data);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          userid: user.uid,
                        )));
          }
          if (ds['usertype'].toString() == "admin") {
            print(ds.data);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminHomePage(
                          userid: user.uid,
                        )));
          }
          if (!ds.exists) {
            print(ds.data);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
        await storeLoginState();
        toggleLoading();
      } else {
        toggleLoading();
        createAlertDialog(context);
      }
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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

  //user verification done here whether they have verified the email or not
  Future userVerification() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    var _authenticatedUser = await _auth.signInWithEmailAndPassword(
        email: email.text, password: password.text);

    if (_authenticatedUser.user.isEmailVerified) {
      setState(() {
        _isUserVerified = true;
      });
    } else {
      setState(() {
        _isUserVerified = false;
      });
    }
  }

//inputs validation
  void _validateForm() {
    try {
      if (formKey.currentState.validate()) {
        loginUser(email.text, password.text);
      }
    } catch (e) {
      print(e.toString());
    }
  }

//widget to create a horizontal line
  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 120,
          height: 2,
          color: Colors.black26.withOpacity(.2),
        ),
      );

//the function to send email verification after its invoked by the dialog
  // Future<void> sendEmailVerification(String email) async {
  //   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //   var user = await _firebaseAuth.currentUser();
  //   user.sendEmailVerification();
  // }

//the dialog popped for the user to invoke sending of the verification code
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Email not yet verified'),
            content: Text('You have to verify your email so as to continue.'),
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
              overflow: Overflow.visible,
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 315,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/background1.png"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(),
                    // ),

                    //this part gave me an error that gave me headache...
                    // interfering with the container class only to find i pasted the image asset in that class,, weee...
                    //  Image.asset("images/image_02.png"),
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
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('images/chaplogo.jpg'),
                              radius: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Ripoti Chapchap',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
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
                            height: 380,
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
                                    'login',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: CupertinoTheme.of(context)
                                            .primaryColor),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: email,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      hintText: "Enter Email",
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
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: password,
                                    obscureText: isHidden,
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
                                              icon: Icon(Icons.visibility_off),
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
                                    height: 35,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Clear",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            email.text = "";
                                            password.text = "";
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      PasswordReset()));
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
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            _validateForm();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            horizontalLine(),
                            Text(
                              'or',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            horizontalLine(),
                          ],
                        ),
                        SizedBox(height: 10),
                        FlatButton(
                          child: Text('Dont have an account.? Sign Up...'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                animating: true,
              ),
            ),
    );
  }
}
