//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

//flutter
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

//logic part
class DisasterSpecificationPage extends StatefulWidget {
  @override
  _DisasterSpecificationPageState createState() =>
      _DisasterSpecificationPageState();
}

class _DisasterSpecificationPageState extends State<DisasterSpecificationPage> {
  final formKey = GlobalKey<FormState>();
  var incidencefield = TextEditingController();
  var naturefield = TextEditingController();

  File _image;
  String url;

  Location location = Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  //the function to upload the disaster when an image is selected by the user
  Future<void> uploadDisasterAndImage(BuildContext context) async {
    toggleLoading();
    try {
      var dbTimeKey = DateTime.now();
      var pos = await location.getLocation();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);

      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var user = await _firebaseAuth.currentUser();
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Disaster Images/$dbTimeKey.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = imageurl.toString();

      print("image uri is:" + url);

      DocumentReference documentReference =
          Firestore.instance.collection('disasters').document();
      Map<String, dynamic> incidences = {
        "description": incidencefield.text,
        "incidence": naturefield.text,
        "time": time,
        "image": imageurl,
        "timestamp": dbTimeKey,
        "date": date,
        "phonenumber": usercontact,
        "disasterid": user.uid,
        "position": {
          "geohash": pos.hashCode.toString(),
          "latitude": pos.latitude.toString(),
          "longitude": pos.longitude.toString(),
        }
      };
      documentReference.setData(incidences).whenComplete(() {
        Fluttertoast.showToast(
            msg:
                'Reported successfully.\n The disaster agents are being notified. \nThankyou',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          incidencefield.text = '';
          naturefield.text = '';
          _image = null;
        });
        toggleLoading();
        print("Disaster uploaded");
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
        msg: "oops! something went wrong.\n Try again",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        backgroundColor: Colors.blue,
      );
      print(e);
    }
  }

//the function to upload the disaster incase no image is selected by the user
  Future<void> uploadDisaster() async {
    toggleLoading();

    try {
      var pos = await location.getLocation();
      var dbTimeKey = DateTime.now();
      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);

      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var user = await _firebaseAuth.currentUser();

      DocumentReference documentReference =
          Firestore.instance.collection('disasters').document();
      Map<String, dynamic> contacts = {
        "description": incidencefield.text,
        "incidence": naturefield.text,
        "time": time,
        "timestamp": dbTimeKey,
        "date": date,
        "phonenumber": usercontact,
        "disasterid": user.uid,
        "position": {
          "geohash": pos.hashCode.toString(),
          "latitude": pos.latitude.toString(),
          "longitude": pos.longitude.toString(),
        }
      };
      documentReference.setData(contacts).whenComplete(() {
        setState(() {
          incidencefield.text = '';
          naturefield.text = '';
        });
        Fluttertoast.showToast(
            msg:
                'Reported successfully. \n The disaster agents are being notified.\n Thankyou',
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
            backgroundColor: Colors.blue);
        toggleLoading();
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
          msg: "oops! something went wrong. \n Try again",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.blue);
    }
  }

//validate inputs
  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      createAlertDialog(context);
    } else {
      return null;
    }
  }

//function to get reporter's contact
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

  @override
  void initState() {
    super.initState();
    _getSenderContact();
  }

//opens the user's device gallery
  _openGallery(BuildContext context) async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

//opens the user's device camera
  _openCamera(BuildContext context) async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

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
                  if (_image != null) {
                    Navigator.of(context).pop();
                    uploadDisasterAndImage(context);
                  } else {
                    Navigator.of(context).pop();
                    uploadDisaster();
                  }
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

//the dialog to be popped when the user needs to select an image
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select the Source',
                style: TextStyle(color: Colors.blue, fontSize: 20)),
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

//the widget to place the image or placeholder in the image container
  Widget _imageView() {
    if (_image != null) {
      try {
        return Image.file(
          _image,
          width: 300,
          height: 400,
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      return Image.asset("images/image_01.png");
    }
    return null;
  }

//loading spinner
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Disaster Specification',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 16),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  "If your issue is not predefined at the home page,\n please specify it in the following fields.\n \nWe are here to help you."),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: naturefield,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    labelText: "Nature of incidence",
                                    helperText:
                                        "like a suspicious gang meeting..."),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "nature required";
                                  }
                                  return null;
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
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
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
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
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                );
              },
            )
          : Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            ),
    );
  }
}
