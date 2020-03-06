import 'package:chap/Admin/UploadAdvice.dart';
import 'package:chap/Admin/UploadContacts.dart';
import 'package:chap/Admin/fcm.dart';
import 'package:chap/Admin/reported.dart';
import 'package:chap/TabFiles/ContactsPage.dart';
import 'package:chap/TabFiles/googlemapPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../About.dart';
import '../Authentication.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplimentation auth;
  final VoidCallback onSignedOut;
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Reported(),
    MessageHandler(),
    UploadAdvicePge(),
    UploadContacts(),
  ];
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget appBarTitle = Text("Welcome Admin");
  Icon searchIcon = Icon(Icons.search);
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
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              // setState(() {
              //   if (this.searchIcon.icon == Icons.search) {
              //     this.searchIcon = Icon(Icons.close);
              //     this.appBarTitle = TextField(
              //       style: TextStyle(color: Colors.white),
              //       decoration: InputDecoration(

              //         prefixIcon: Icon(
              //           Icons.search,
              //           color: Colors.white,

              //         ),
              //         hintText: "Disaster id",
              //         hintStyle: TextStyle(color: Colors.white),
              //       ),
              //     );
              //   } else {
              //     this.searchIcon = Icon(Icons.search);
              //     this.appBarTitle = Text("Welcome Admin");
              //   }
              // });

              showSearch(context: context, delegate: DataSearch());
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Feedback"),
                ),
              ];
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
         
          Icon(
            Icons.home,
            color: Colors.black,
            size: 20,
          ),
           Icon(
            Icons.message,
            color: Colors.black,
            size: 20,
          ),
          Icon(
            Icons.add_comment,
            color: Colors.black,
            size: 20,
          ),
          Icon(
            Icons.contacts,
            color: Colors.black,
            size: 20,
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
        index: 1,
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          onTappedBar(index);
          debugPrint('the index is: $index');
        },
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final ids = ["0023", "0045", "0483", "34342", "4553"];
  final recentids = ["0483", "34342", "4553"];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      title: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentids
        : ids.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.live_help),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
