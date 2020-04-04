//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//pages
import 'package:chap/Admin/DisasterImagePage.dart';

//logic part
class ReportedDisasters extends StatefulWidget {
  @override
  _ReportedDisastersState createState() => _ReportedDisastersState();
}

class _ReportedDisastersState extends State<ReportedDisasters> {
  //pagination starts
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _disasters = [];
  bool _loadingDisasters = true;
  int _perPage = 5;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();
  bool _gettingMoreDisasters = false;
  bool _moreDisastersAvailable = true;
  String imgPath;
  String _description;
  String _location;

//query to load perpage disasters content
  _getDisasters() async {
    Query q = _firestore
        .collection("disasters")
        .orderBy('timestamp', descending: true)
        .limit(_perPage);
    setState(() {
      _loadingDisasters = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    _disasters = querySnapshot.documents;
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    setState(() {
      _loadingDisasters = false;
    });
  }

//called to load more disasters after listening to scrolling event
  _getMoreDisasters() async {
    print("get more disasters called");
    if (_moreDisastersAvailable == false) {
      print("no more disasters");
      return;
    }
    if (_gettingMoreDisasters == true) {
      return;
    }
    _gettingMoreDisasters = true;
    Query q = _firestore
        .collection("disasters")
        .orderBy('timestamp', descending: true)
        .startAfter([_lastDocument.data['timestamp']]).limit(_perPage);

    QuerySnapshot querySnapshot = await q.getDocuments();
    if (querySnapshot.documents.length < _perPage) {
      _moreDisastersAvailable = false;
    }
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    _disasters.addAll(querySnapshot.documents);
    setState(() {});
    _gettingMoreDisasters = false;
  }

//the perpage disasters are loaded from the firestore on the initial state and a scrolling listener
  @override
  void initState() {
    super.initState();
    _getDisasters();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        _getMoreDisasters();
      }
    });
  }

//call launcher
  launchCaller(String contact) async {
    String phoneno = "tel:${contact.toString()}";
    if (await canLaunch(phoneno)) {
      await launch(phoneno);
    } else {
      throw "Could not place a call";
    }
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !_loadingDisasters
            ? Container(
                child: _disasters.length == 0
                    ? Center(
                        child: Text('no disasters reported'),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _disasters.length,
                        itemBuilder: (BuildContext context, int index) {
                          String time =
                              _disasters[index].data['time'].toString();
                          String date =
                              _disasters[index].data['date'].toString();
                          String incidence =
                              _disasters[index].data['incidence'].toString();
                          String description =
                              _disasters[index].data['description'].toString();
                          String contact =
                              _disasters[index].data['phonenumber'];

                          String location =
                              _disasters[index].data['position'].toString();
                          String image =
                              _disasters[index].data['image'].toString();

                          return GestureDetector(
                            child: Card(
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ListTile(
                                    leading: Text(
                                      date,
                                    ),
                                    trailing: Text(time),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'INCIDENCE:',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(width: 20),
                                        Text(incidence),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'REPORTED BY:',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(child: Text(contact)),
                                        IconButton(
                                            icon: Icon(
                                              Icons.call,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              launchCaller(contact);
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'LOCATION:',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Text(location.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("STATUS:",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        Text("RESPONDED",
                                            style:
                                                TextStyle(color: Colors.green)),
                                        Container(
                                          color: Colors.green,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (image != null) {
                                  imgPath = image;
                                  _description = description;
                                  _location = location;
                                }
                              });
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => DisasterImagePage(
                                            assetPath: imgPath,
                                            descriptionPath: _description,
                                            locationPath: _location,
                                          )));
                            },
                          );
                        },
                      ),
              )
            : Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              ));
  }
}
