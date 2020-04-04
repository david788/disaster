//firebase
import 'dart:async';

import 'package:chap/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//pages
import 'package:chap/TabFiles/ContactsPage.dart';
import 'package:chap/TabFiles/DisasterSpecificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'About.dart';
import 'DisasterDetails.dart';
import 'TabFiles/Advice.dart';

//logic part
class HomePage extends StatefulWidget {
  HomePage({this.userid});
  final userid;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //getting the users details for the drawer header from the firestore
  Future getDetails() async {
    var user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        useremail = ds['email'];
        usercontact = ds['contact'];
        usertype = ds['usertype'];
      });
    });
  }

//alert dialog to alert the user of being logged out from the app
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Icon(Icons.warning), Text('logging out!')],
            ),
            content: Text("You are about to log out..."),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  // logOutUser();
                  logOut();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//the function to log out the user from the app and set the state to signed out

  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('useremail', null);
    prefs.remove('useremail');
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    await _firebaseAuth.signOut();

    setState(() {
      // useremail = "";
      isLoggedIn = false;
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => LoginPage()));
    });
  }

  String useremail = '';
  String usercontact = '';
  String usertype = '';
  String imgPath;
  String name;
  bool isLoggedIn = false;

  //user details are gotten in the initial state
  @override
  void initState() {
    super.initState();
    getDetails();
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Ripoti ChapChap',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: Text("Welcome Client"),
                  ),
                )
              ];
            })
          ]),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor,
              ),
              child: Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage("images/image_01.png"),
                      radius: 60,
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      top: 10,
                      start: 160,
                      child: Text("User:" + "  " + usertype,
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      top: 40,
                      start: 160,
                      child: Text(
                        usercontact,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Positioned.directional(
                      top: 120,
                      textDirection: TextDirection.ltr,
                      child: Text(
                        useremail,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Call us'),
              leading: Icon(
                Icons.call,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Contacts()));
              },
            ),
            ListTile(
              title: Text('Advice'),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AdvicePage()));
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AboutPage()));
              },
            ),
            Divider(
              height: 2,
              color: Colors.blue,
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () {
                createAlertDialog(context);
              },
            ),
          ],
        ),
      ),
      //body contains the files from firestore, its dynamic
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('incidences')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Text('Error');
          else if (!snapshot.hasData) {
            print('no data');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            default:
              return ListView(
                  children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: Image.network(
                                      document['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 50,
                                    right: 50,
                                    child: Material(
                                      color: Colors.black54,
                                      child: Center(
                                        child: Text(
                                          document['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        imgPath = document['image'];
                        name = document['name'];
                      });
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => DisasterDetail(
                              assetPath: imgPath, disasterName: name)));
                    },
                  );
                },
              ).toList());
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 10,
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => DisasterSpecificationPage()));
          }),
    );
  }
}
