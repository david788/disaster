import 'package:chap/MainControllerPage.dart';
import 'package:chap/TabFiles/googlemapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DisasterDetail extends StatefulWidget {
  final assetPath, disasterName;
  DisasterDetail({this.assetPath, this.disasterName});

  @override
  _DisasterDetailState createState() => _DisasterDetailState();
}

class _DisasterDetailState extends State<DisasterDetail> {
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  String _description;
  // String _disastername;
  getDescription(_description) {
    this._description = _description;
  }

  // getDisasterName(_disastername) {
  //   this._disastername = _disastername;
  // }

  final formKey = GlobalKey<FormState>();
  var description = TextEditingController();

  void uploadToFirestore() async {
    try {
      toggleLoading();
      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);
      DocumentReference documentReference =
          Firestore.instance.collection('disasters').document();
      Map<String, dynamic> disasters = {
        "description": _description,
        "incidence": widget.disasterName,
        "time": time,
        "date": date,
      };
      documentReference.setData(disasters).whenComplete(() {
        toggleLoading();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainControllerPage()));

        Fluttertoast.showToast(
            msg:
                'Reported successfully. The disaster agents are being notified. Thankyou',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: '$e'.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void validate() {
    if (formKey.currentState.validate()) {
      createAlertDialog(context);
    } else {}
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Report this Incidence.?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
                onPressed: () {
                  uploadToFirestore();
                  Navigator.of(context).pop();
                  setState(() {
                    description.text = '';
                  });
                },
              ),
              MaterialButton(
                elevation: 5,
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Ripoti ChapChap'),
            centerTitle: true,
          ),
          body: !loading
              ? Builder(builder: (context) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Disaster',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: widget.assetPath,
                        child: Image.asset(
                          widget.assetPath,
                          height: 180,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Text(
                          widget.disasterName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add_location,
                                size: 30, color: Colors.blue),
                            onPressed: () {},
                          ),
                          RaisedButton(
                            color: Colors.blueAccent,
                            child: Text(
                              'Pick Location',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoogleMapPage()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: description,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                labelText: "Description",
                                hintText: "PLease give a small description"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please give a brief description of the incident';
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              return _description = value;
                            },
                            onChanged: (String _description) {
                              getDescription(_description);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          child: InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF17ead9),
                                    Color(0xFF6078ea)
                                  ]),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0.0, 8.0),
                                        blurRadius: 8.0),
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    validate();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Report",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 34,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
              : Center(
                  child: CupertinoActivityIndicator(radius: 20),
                ));
    });
  }
}

class AlertUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SnackBar mySnackBar = SnackBar(
      content: Text('Thanks'),
    );
    Scaffold.of(context).showSnackBar(mySnackBar);
    return Builder(builder: (context) {
      return Scaffold();
    });
  }
}
