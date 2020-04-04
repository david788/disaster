//firebase
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:chap/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  var email = TextEditingController();

  final formKey = GlobalKey<FormState>();

  //input validation
  void validateandsubmit() async {
    try {
      if (formKey.currentState.validate()) {
        await resetEmailPassword(email.text);
        print(email.text);
      }
    } catch (e) {
      print("error is: " + e.toString());
    }
  }

//loading spinner
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

//the function to send email reset code to the email provided
  Future<void> resetEmailPassword(var email) async {
    try {
      toggleLoading();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => LoginPage()));

      Fluttertoast.showToast(
        msg: "A reset code has been sent to your email.\n\n Check your email.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      toggleLoading();
    } catch (e) {
      toggleLoading();

      Fluttertoast.showToast(
        msg: "oops! something wrong happened",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      print(e.toString());
    }
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: !loading
            ? CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: this._pinned,
                    snap: this._snap,
                    floating: this._floating,
                    expandedHeight: 200,
                    iconTheme: IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'images/image_01.png',
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "Reset Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
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
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          CupertinoButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "submit",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                validateandsubmit();
                              })
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
