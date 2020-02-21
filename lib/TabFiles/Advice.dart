import 'package:chap/TabFiles/ContactsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('advice').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child:CupertinoActivityIndicator(
              radius: 20,
            ));
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext context, int index) {
        String title = widget.documents[index].data['title'].toString();
        String content = widget.documents[index].data['content'].toString();
        return ListTile(
          title: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              
            ),
            
            child: Column(
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 20),),
                SizedBox(height:10),
              ],
            ),
          ),
          subtitle: Text(content, style: TextStyle(fontSize:16),),
        );
      },
    );
  }
}
