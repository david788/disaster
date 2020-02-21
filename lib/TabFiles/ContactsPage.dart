import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('contacts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child:CupertinoActivityIndicator(radius: 20,));

          return FirestoreListView(documents: snapshot.data.documents);
        },
      ),
    );
  }
}

class FirestoreListView extends StatefulWidget {
  
  final List<DocumentSnapshot> documents;
  FirestoreListView({this.documents});

  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView> {
  void _launchCaller(int number) async {
    var url = "tel:${number.toString()}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not place a call";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext context, int index) {
        String location = widget.documents[index].data['location'].toString();
        String contact = widget.documents[index].data['contact'].toString();
        

        return ListTile(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(location),
                ),
                Expanded(child: Text(contact.toString()))
              ],
            ),
          ),
          leading: FaIcon(FontAwesomeIcons.personBooth, color: Colors.blue),
          trailing: IconButton(
              icon: Icon(
                
                Icons.call,
                color: Colors.blueAccent,
              ),
              onPressed: (){
                // _launchCaller(contact.toString());
              }
              ),
              onLongPress: (){},
        );
      },
    );
  }
}
