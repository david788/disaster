//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//logic part
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  //ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            "About Us",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('about').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text("no data"));
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CupertinoActivityIndicator(
                radius: 20,
              ));
            default:
              return AboutList(documents: snapshot.data.documents);
          }
        },
      ),
    );
  }
}

class AboutList extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  AboutList({this.documents});
  @override
  _AboutListState createState() => _AboutListState();
}

class _AboutListState extends State<AboutList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext context, int index) {
        String aboutUs = widget.documents[index].data['aboutapp'].toString();

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    aboutUs,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          onLongPress: () {},
        );
      },
    );
  }
}
