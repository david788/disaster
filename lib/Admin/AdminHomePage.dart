//firebase
import 'package:chap/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

//pages
import 'package:chap/Admin/ReportedDisasters.dart';
import 'package:chap/Admin/UploadAdvice.dart';
import 'package:chap/Admin/UploadContacts.dart';
import 'package:chap/Admin/UploadIncidence.dart';
import 'package:chap/Admin/fcm.dart';
import 'package:chap/TabFiles/Advice.dart';
import 'package:chap/TabFiles/ContactsPage.dart';
import 'package:chap/TabFiles/googlemapPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../About.dart';

//logic part
class AdminHomePage extends StatefulWidget {
  AdminHomePage({  this.userid});
  final userid;

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  //the bottom navigation bar pages
  int _currentIndex = 0;
  final List<Widget> _children = [
    ReportedDisasters(),
    MessageHandler(),
    UploadAdvicePge(),
    UploadContacts(),
    UploadIncidence(),
  ];
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Icon searchIcon = Icon(Icons.search);

  //logout user from the app
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

//alert dialog to alert the user on logging out event
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Icon(Icons.exit_to_app), Text('logging out!')],
            ),
            content: Text("you are about to log out..."),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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

//user details for the drawer header
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

  String useremail = '';
  String usercontact = '';
  String usertype = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: Text('Contact Us'),
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
              title: Text(
                'See Maps',
              ),
              leading: Icon(
                Icons.map,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => GoogleMapPage()));
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
      appBar: AppBar(
        title: Text(
          'Administrator',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Welcome Admin"),
                ),
              ];
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.cyan,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.cyan,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.home,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.message,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.add_comment,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.contacts,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.add_to_photos,
            color: Colors.white,
            size: 20,
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
        index: 2,
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
