import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportedDisasters extends StatefulWidget {
  @override
  _ReportedDisastersState createState() => _ReportedDisastersState();
}

class _ReportedDisastersState extends State<ReportedDisasters> {
  List<Disasters> disastersList = [];
  //fetch from firebase child "Disasters"
  List<Disasters> selectedDisaster;
  //to enable select a row
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

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
  void initState() {
    selectedDisaster = [];
    super.initState();
    DatabaseReference disastersRef =
        FirebaseDatabase.instance.reference().child("Disasters");
    disastersRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      disastersList
          .clear(); //the data to be fetched from firebase in Disasters child nodes
      for (var individualKey in KEYS) {
        Disasters disasters = Disasters(
          DATA[individualKey]["date"],
          DATA[individualKey]["time"],
          DATA[individualKey]["image"],
          DATA[individualKey]["description"],
          DATA[individualKey]["location"],
        );
        disastersList.add(disasters);
      }
      setState(() {
        print('Length: ${disastersList.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: disastersList.length == 0
              ? Center(
                  // child: Text("loading"),
                  child: Text(
                    "PLease Wait... loading Disasters",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
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
                                  DataCell(Text(disaster.time)),
                                  DataCell(Text(disaster.date)),
                                  DataCell(Text(disaster.description)),
                                  DataCell(Text(disaster.location)),
                                ]))
                        .toList(),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
          child: Text('${selectedDisaster.length}'), onPressed: null),
    );
  }
}

//the data is accessed through the Disasters class below
class Disasters {
  String date, time, image, description, location;
  Disasters(this.date, this.time, this.image, this.description, this.location);
  // List<Disasters> getDisasters() {
  //   return [Disasters(date, time, image, description, location)];
  // }
}
