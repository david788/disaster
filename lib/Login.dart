import 'package:chap/MainControllerPage.dart';
import 'package:chap/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Authentication.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final AuthImplimentation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  String _myemail;
  String _mypassword;
  final formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> loginUser(var email, var password) async {
    try {
      toggleLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MainControllerPage()));

      toggleLoading();
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));

      print(e.toString());
      Fluttertoast.showToast(msg: '$e',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blueAccent,);
    }
    widget.onSignedIn();
  }

  void _validateForm() {
    try {
      if (formKey.currentState.validate()) {
        loginUser(email.text, password.text);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getCurrentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser.uid;
  }

  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 120,
          height: 2,
          color: Colors.black26.withOpacity(.2),
        ),
      );
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
                      child: Image.asset("images/image_01.png"),
                    ),
                    Expanded(
                      child: Container(),
                    ),

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
                            Image.asset("images/logo.png"),
                            Text(
                              'Ripoti Chapchap',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        // FormCard(),
                        Form(
                          key: formKey,
                          child: Container(
                            width: double.infinity,
                            height: 410,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'login',
                                    style: TextStyle(
                                        fontSize: 45,
                                        color: CupertinoTheme.of(context)
                                            .primaryColor),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text("Email", style: TextStyle(fontSize: 22)),
                                   TextFormField(
                                        controller: email,
                                        // keyboardType:
                                        //     TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: "Enter Email",
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "please enter email";
                                          }
                                            if (!value.contains('@')){
                                            return "email is badly formated";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          return _myemail = value;
                                        },
                                      ),
                                  
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text("Password",
                                      style: TextStyle(fontSize: 22)),
                                       TextFormField(
                                        controller: password,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: "Enter Password",
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "please enter password";
                                          }
                                        
                                          else {
                                            return null;
                                          }
                                          // switch(value){
                                          //   case value.isEmpty:
                                          //   return "";

                                          // }
                                        },
                                        onSaved: (value) {
                                          return _mypassword = value;
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
                                            fontSize: 16,
                                            color: Colors.blue,
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
                                            color: Colors.blue,
                                          ),
                                        ),
                                        onPressed: () {},
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
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            _validateForm();

                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainControllerPage()));
                          },
                        ),
                        SizedBox(
                          height: 10,
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
                        FlatButton(
                          child: Text('Dont have an account.? Create new'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text("please wait..."),
                  ),
                ),
                Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                    animating: true,
                  ),
                )
              ],
            ),
    );
  }
}
