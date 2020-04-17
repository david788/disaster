//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//pages
import 'package:chap/Admin/AdminHomePage.dart';

import 'HomePage.dart';

//logic part
class MappingPage extends StatefulWidget {
  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus {
  signedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.signedIn;
  @override
  void initState() {
    super.initState();
    checkUser();
  }

//check the usertype to know the pages to reroute to
  var usertype = '';
  void checkUser() async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          if (ds['usertype'].toString() == 'client') {
            usertype = "client";
          }
          if (ds['usertype'].toString() == 'admin') {
            usertype = 'admin';
          }
          return ds['usertype'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

//ui part
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.signedIn:
        // checkUser();

        if (usertype.toString() == 'client') {
          return HomePage();
        }
        if (usertype.toString() == 'admin') {
          return AdminHomePage();
        }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(colors: [
                Colors.cyanAccent,
                // Colors.indigo,
                Colors.blueAccent,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 125,
                backgroundImage: AssetImage("images/dstech.png"),
              ),
              // AnimatedContainer(
              //   duration: Duration(milliseconds: 500),
              //   curve: Curves.easeOutQuint,
              //   margin: EdgeInsets.only(top: 100, bottom: 50, right: 30),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       image: DecorationImage(
              //         fit: BoxFit.cover,
              //         image: AssetImage("images/image_01.png"),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black87,
              //         )
              //       ]),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Okoa Maisha',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
          Positioned.directional(
            bottom: 20,
            start: 50,
            end: 50,
            textDirection: TextDirection.ltr,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '© Davikk Softwares Co Ltd.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          Positioned.directional(
            top: 40,
            start: 50,
            end: 50,
            textDirection: TextDirection.ltr,
            child: Center(
              child: Text(
                'Ripoti ChapChap',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
