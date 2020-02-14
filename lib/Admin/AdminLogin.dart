import 'package:chap/Admin/AdminHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  final formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var adminid = TextEditingController();
  String _myemail;
  String _mypassword;
  String _myadminid;

  Future<void> loginUser(var email, var password) async {
    try {
      toggleLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      toggleLoading();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminLoginPage()));

      print(e.toString());
    }
  }

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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
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
                            height: 500,
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
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 45,
                                        color: CupertinoTheme.of(context)
                                            .primaryColor),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Email", style: TextStyle(fontSize: 20)),
                                  TextFormField(
                                    controller: email,
                                    decoration: InputDecoration(
                                      hintText: "Enter Email",
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "please enter email";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      return _myemail = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Password",
                                      style: TextStyle(fontSize: 20)),
                                  TextFormField(
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Enter Password",
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "please enter password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      return _mypassword = value;
                                    },
                                  ),
                                  Text("Admin Id",
                                      style: TextStyle(fontSize: 26)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: adminid,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Enter Admin Id",
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "please enter admin id";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      return _myadminid = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
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
                                            password.text = "";
                                            email.text = "";
                                            adminid.text = "";
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
                            validate();
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
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom:10),
                  child: Center(
                    child: Text("please wait..."),
                  ),
                ),
                Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                )
              ],
            ),
    );
  }

  void validate() {
    if (formKey.currentState.validate()) {
      loginUser(email.text, password.text);
    } else {
      return null;
    }

   
  }
}
