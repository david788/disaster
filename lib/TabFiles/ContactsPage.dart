//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//logic part
class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  //ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Help Contacts',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('contacts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text("no contacts"));
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CupertinoActivityIndicator(
                radius: 20,
              ));
            default:
              return FirestoreListView(documents: snapshot.data.documents);
          }
        },
      ),
    );
  }
}

//logic part
class FirestoreListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FirestoreListView({this.documents});

  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView> {
  // dialer function to open the call dialer of the user's device
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
    return ListView.builder(
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext context, int index) {
        String location = widget.documents[index].data['location'].toString();
        String contact = widget.documents[index].data['contact'];

        return ListTile(
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(location),
              ),
              Expanded(child: Text(contact))
            ],
          ),
          leading: Icon(Icons.people_outline),
          trailing: IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                launchCaller(contact);
              }),
          onLongPress: () {},
        );
      },
    );
  }
}
