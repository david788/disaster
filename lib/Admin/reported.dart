import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reported extends StatefulWidget {
  @override
  _ReportedState createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
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
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Text('Loading disasters');
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot disasters = snapshot.data.documents[index];
                  return DataTable(
                    columns: [
                      DataColumn(label: Text("TIME"), numeric: false),
                      DataColumn(label: Text("DATE"), numeric: false),
                      DataColumn(label: Text("DISASTER"), numeric: false),
                      DataColumn(label: Text("LOCATION"), numeric: false),
                    ],
                    rows: disastersList
                        .map((disaster) => DataRow(
                                selected: selectedDisaster.contains(disaster),
                                onSelectChanged: (b) {
                                  print("Onselect");
                                  onSelectedRow(b, disaster);
                                },
                                cells: [
                                  DataCell(Text('${disasters["time"]}')),
                                  DataCell(Text('${disasters["date"]}')),
                                  DataCell(Text('${disasters["disaster"]}')),
                                  DataCell(Text('${disasters["location"]}')),
                                ]))
                        .toList(),
                  );
                });
          }
        },
        stream: Firestore.instance.collection('Disasters').snapshots(),
      ),
    );
  }
}

class Disasters {
  String date, time, image, description, location;
  Disasters(this.date, this.time, this.image, this.description, this.location);
  // List<Disasters> getDisasters() {
  //   return [Disasters(date, time, image, description, location)];
  // }
}
