import 'package:chap/About.dart';
import 'package:chap/DisasterPage.dart';
import 'package:chap/TabFiles/Advice.dart';
import 'package:chap/TabFiles/ContactsPage.dart';
import 'package:chap/TabFiles/googlemapPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';

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
    // HomePage(),
    DisasterPage(),
    AdvicePage(),
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Icon(Icons.add_alert), Text('logging out!')],
            ),
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contacts()));
              },
            ),
            ListTile(
              title: Text('See Maps'),
              leading: Icon(Icons.map),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GoogleMapPage()));
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
            Divider(
              height: 2,
              color: Colors.blue,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom:1),
        child: CurvedNavigationBar(
         

          color: Colors.blueAccent,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.blue,
          height: 70,

          items: <Widget>[
            Column(
              children: <Widget>[
                IconButton(icon: Icon(Icons.home, color: Colors.white,), onPressed: null),
                Text('Home', style: TextStyle(color: Colors.white,)),
              ],
            ),
            Column(
              children: <Widget>[
                IconButton(icon: Icon(Icons.list, color: Colors.white,), onPressed: null),
                Text('Advice',
                    style: TextStyle(color: Colors.white, )),
              ],
            ),
          ],
          animationDuration: Duration(milliseconds: 600),
          animationCurve: Curves.bounceInOut,
          // index: 1,
          onTap: (index) {
            onTappedBar(index);
            debugPrint('current index is:$index');
          },
        ),
      ),
    );
  }
}
