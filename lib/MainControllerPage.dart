import 'package:chap/HomePage.dart';
import 'package:chap/TabFiles/Contacts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Authentication.dart';
import 'MainControllerPages/AboutPage.dart';

class MainControllerPage extends StatefulWidget {
  MainControllerPage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplimentation auth;
  final VoidCallback onSignedOut;

  @override
  _MainControllerPageState createState() => _MainControllerPageState();
}

class _MainControllerPageState extends State<MainControllerPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    AboutPage(),
    ContactsPage(),
  ];
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('You are about to log out'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  logOutUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Ripoti ChapChap'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: Text("Rate Us"),
                  ),
                  // child: Text("Rate Us"),
                )
              ];
            })
          ]),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              curve: Curves.bounceInOut,
              child: Text(
                'Ripoti chapchap',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor,
                image:
                    DecorationImage(image: AssetImage("images/image_01.png")),
              ),
            ),
            ListTile(
              title: Text('Contact Us'),
              leading: Icon(Icons.call),
              onTap: () {},
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.info),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "About",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
            ListTile(
              title: Text('More'),
              leading: Icon(Icons.more),
              onTap: () {},
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                createAlertDialog(context);
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // onTap: onTappedBar,
        //  currentIndex = _currentIndex,

        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 50,

        items: <Widget>[
          Icon(Icons.home, size: 20, color: Colors.black),
          Icon(Icons.list, size: 20, color: Colors.black),
          Icon(Icons.exit_to_app, size: 20, color: Colors.black),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        index: 1,
        onTap: (index) {
          onTappedBar(index);
          debugPrint('current index is:$index');
        },
      ),
    );
  }
}
