//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//logic part
class DisasterDetail extends StatefulWidget {
  final assetPath, disasterName;
  DisasterDetail({this.assetPath, this.disasterName});

  @override
  _DisasterDetailState createState() => _DisasterDetailState();
}

class _DisasterDetailState extends State<DisasterDetail> {
  //loading spinner
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  final formKey = GlobalKey<FormState>();
  var description = TextEditingController();
  var phoneNumber = TextEditingController();

  Location location = Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

//for fireship
  Future<DocumentReference> _addGeoPoint() async {
    try {
      toggleLoading();

      var pos = await location.getLocation();
      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');
      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);

      GeoFirePoint point =
          geo.point(latitude: pos.latitude, longitude: pos.longitude);
      return firestore.collection('disasters').add({
        "time": time,
        "date": date,
        "incidence": widget.disasterName,
        "description": description.text,
        'position': point.data,
      }).whenComplete(() {
        Fluttertoast.showToast(
            msg:
                'Reported successfully. The disaster agents are being notified. Thankyou',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        toggleLoading();
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
          msg: '$e'.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

//function to retrieve the reporter's contact automatically
  Future _getSenderContact() async {
    var user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        usercontact = ds['contact'];
      });
    });
  }

  String usercontact = '';
//contact gotten on the initial state
  @override
  void initState() {
    super.initState();
    _getSenderContact();
  }

//the function to upload the disaster to firestore
  void uploadToFirestore() async {
    toggleLoading();
    try {
      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);
      var pos = await Location().getLocation();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var user = await _firebaseAuth.currentUser();

      DocumentReference documentReference =
          Firestore.instance.collection('disasters').document();
      Map<String, dynamic> disasters = {
        "description": description.text,
        "incidence": widget.disasterName,
        "time": time,
        "timestamp": dbTimeKey,
        "date": date,
        "phonenumber": usercontact,
        "disasterid": user.uid,
        "position": {
          "geohash": pos.hashCode.toString(),
          "latitude": pos.latitude.toString(),
          "longitude": pos.longitude.toString()
        }
      };
      documentReference.setData(disasters).whenComplete(() {
        setState(() {
          description.text = '';
        });
        toggleLoading();
        Fluttertoast.showToast(
            msg:
                'Reported successfully.\n The disaster agents are being notified. \nThankyou',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
          msg: 'oops! an error occurred.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

//validate function for inputs
  void validate() {
    if (formKey.currentState.validate()) {
      createAlertDialog(context);
    } else {
      return null;
    }
  }

//a dialog to alert the reporter to confirm the incidence
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Warning!',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            content: Text("This disaster will be reported now."),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
                onPressed: () {
                  // _addGeoPoint();
                  Navigator.pop(context);
                  uploadToFirestore();
                },
              ),
              MaterialButton(
                elevation: 5,
                child: Text(
                  'Dismiss',
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

//ui part
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Ripoti ChapChap',
              style: TextStyle(color: Colors.white),
            ),
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: widget.assetPath,
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.assetPath),
                                fit: BoxFit.fill),
                          ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: formKey,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    // keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    controller: description,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        labelText: "Description",
                                        hintText:
                                            "PLease give a small description"),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please give a brief description of the incident';
                                      } else
                                        return null;
                                    },
                                  ),
                                ],
                              ),
                            )),
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
