import 'dart:io';

import 'package:chap/MainControllerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class DisasterSpecificationPage extends StatefulWidget {
  @override
  _DisasterSpecificationPageState createState() =>
      _DisasterSpecificationPageState();
}

class _DisasterSpecificationPageState extends State<DisasterSpecificationPage> {
  final formKey = GlobalKey<FormState>();
  var incidencefield = TextEditingController();
  var locationfield = TextEditingController();

  File imageFile;
  String _mydescription;
  String _incidence;
  String url;
  Location location = Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Future<DocumentReference> _addGeoPoint() async {
    try {
      toggleLoading();

      var pos = await location.getLocation();
      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);
      StorageReference ref =
          FirebaseStorage.instance.ref().child("Disaster Images/$time.jpg");
      StorageUploadTask uploadTask =  ref.putFile(imageFile);
      String du = await ref.getDownloadURL();
      return (await uploadTask.onComplete)
          .ref
          .getDownloadURL()
          .whenComplete(() {
        GeoFirePoint point =
            geo.point(latitude: pos.latitude, longitude: pos.longitude);

        return firestore.collection('disasters').add({
          "time": time,
          "date": date,
          "incidence": _incidence,
          "description": _mydescription,
          'position': point.data,
          "image": du
        }).whenComplete(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainControllerPage()));

          Fluttertoast.showToast(
              msg:
                  'Reported successfully. The disaster agents are being notified. Thankyou',
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          toggleLoading();
        });
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

  _openGallery(BuildContext context) async {
    final File picture =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      return this.imageFile = picture;
    });
    print('image path$imageFile');
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final picture = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      return this.imageFile = picture;
    });
    print('image path$imageFile');
    Navigator.of(context).pop();
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
                  // _addGeoPoint();
                  _addGeoPoint();
                  Navigator.of(context).pop();
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

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select the Source'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text('Camera'),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _imageView() {
    if (imageFile != null) {
      try {
        return Image.file(
          imageFile,
          width: 300,
          height: 400,
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      return Text('No image selected');
    }
    return null;
  }

  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate() && imageFile != null) {
      form.save();
      createAlertDialog(context);

    } else {
      // return false;
      Fluttertoast.showToast(
          msg: 'please capture an image to help us serve you better.',
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          );
    }
  }

  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Specification'),
        centerTitle: true,
      ),
      body: !loading
          ? Builder(
              builder: (context) {
                return Form(
                  key: formKey,
                  child: ListView(
                    padding: EdgeInsets.only(left: 20),
                    children: <Widget>[
                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 16),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              
                              TextFormField(
                                controller: locationfield,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)),
                                    labelText: "Nature of incidence",
                                    helperText: "like a strange demonstration"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Location required";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  return _incidence = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                                controller: incidencefield,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    labelText: "Describe the incidence",
                                    helperText: "What happened..?"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Description required";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  return _mydescription = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 420,
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, right: 16),
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.only(right: 4, left: 4),
                            borderOnForeground: true,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[_imageView()],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Capture Photo",
                            style: TextStyle(fontSize: 25),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Material(
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
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0),
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  validateAndSave();
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
                      SizedBox(height: 20)
                    ],
                  ),
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Reporting..."),
                ),
                SizedBox(height: 20),
                Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                )
              ],
            ),
    );
  }
}
