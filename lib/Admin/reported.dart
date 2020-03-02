import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reported extends StatefulWidget {
  @override
  _ReportedState createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: Firestore.instance.collection('disasters').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CupertinoActivityIndicator(
            radius: 20,
          ));

        return FirestoreListView(documents: snapshot.data.documents);
      },
    ));
  }
}

class FirestoreListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FirestoreListView({this.documents});

  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView> {
  List<Disasters> disastersList = [];
  List<Disasters> selectedDisaster;

  onSelectedRow(bool selected, Disasters disaster) async {
    setState(() {
      if (selected) {
        selectedDisaster.add(disaster);
      } else {
        selectedDisaster.remove(disaster);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext context, int index) {
       
         String time = widget.documents[index].data['time'].toString();
        String date = widget.documents[index].data['date'].toString();
        String incidence = widget.documents[index].data['incidence'].toString();
        String description =
            widget.documents[index].data['description'].toString();
                    String location = widget.documents[index].data['position'].toString();

       

        return DataTable(
            columns: [
              DataColumn(label: Text("TIME"), numeric: false),
              DataColumn(label: Text("DATE"), numeric: false),
              DataColumn(label: Text("INCIDENCE"), numeric: false),
              DataColumn(label: Text("DESCRIPTION"), numeric: false),
            ],
            // rows: disastersList.map((disasters) => DataRow(cells: [
            //       DataCell(Text(disasters.time)),
            //       DataCell(Text(disasters.date)),
            //       DataCell(Text(disasters.incidence)),
            //       DataCell(Text(disasters.description)),
            //     ])),
            rows: [DataRow(cells: [
                DataCell(Text(time)),
                DataCell(Text(date)),
                DataCell(Text(incidence)),
                DataCell(Text(description)),
              ])] 
             
            
                );
        // return Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Card(
        //       elevation: 5,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: <Widget>[
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               // crossAxisAlignment: CrossAxisAlignment.center,
        //               children: <Widget>[
        //                 Text('TIME:'),
        //                 Text(time),
        //             ],),
        //           ),
        //            Padding(
        //              padding: const EdgeInsets.all(8.0),
        //              child: Row(
        //               children: <Widget>[
        //                 Text('DATE:'),
        //                 Text(date),
        //           ],),
        //            ),
        //            Padding(
        //              padding: const EdgeInsets.all(8.0),
        //              child: Row(
        //               children: <Widget>[
        //                 Text('INCIDENCE:'),
        //                 Text(incidence),
        //           ],),
        //            ),
        //            Padding(
        //              padding: const EdgeInsets.all(8.0),
        //              child: Row(
        //               children: <Widget>[
        //                 Text('DESCRIPTION:'),
        //                 Text(description),
        //           ],),
        //            ),
        //            Padding(
        //              padding: const EdgeInsets.all(8.0),
        //              child: Row(
        //               children: <Widget>[
        //                 Text('LOCATION:'),
        //                 Expanded(child: Text(location)),
        //           ],),
        //            )
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}

class Disasters {
  
  String date, time, image, description, location, incidence;
  Disasters(this.date, this.time, this.image, this.description, this.location,
      this.incidence);
  // List<Disasters> getDisasters() {
  //   return [Disasters(date, time, image, description, location)];
  // }
}
