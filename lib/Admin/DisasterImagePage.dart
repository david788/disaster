import 'package:flutter/material.dart';

//logic part
class DisasterImagePage extends StatefulWidget {
  final assetPath, descriptionPath, locationPath;
  DisasterImagePage({this.assetPath, this.descriptionPath, this.locationPath});
  @override
  _DisasterImagePageState createState() => _DisasterImagePageState();
}

class _DisasterImagePageState extends State<DisasterImagePage> {
  //ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disaster Image",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: widget.assetPath,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.assetPath), fit: BoxFit.fill),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'DESCRIPTION:',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.descriptionPath),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'LOCATION:',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.locationPath),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
