//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//flutter
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

//logic part
class UploadIncidence extends StatefulWidget {
  @override
  _UploadIncidenceState createState() => _UploadIncidenceState();
}

class _UploadIncidenceState extends State<UploadIncidence> {
  final formKey = GlobalKey<FormState>();
  var disastername = TextEditingController();

  File _image;
  //the function to upload incidence image and title to firestore
  Future<void> uploadIncidence(BuildContext context) async {
    toggleLoading();
    try {
      var dbTimeKey = DateTime.now();
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Incidence Images/$dbTimeKey.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = imageurl.toString();

      print("image uri is:" + url);

      DocumentReference documentReference =
          Firestore.instance.collection('incidences').document();
      Map<String, dynamic> incidences = {
        'image': imageurl,
        'name': disastername.text,
        'timestamp': DateTime.now(),
      };
      documentReference.setData(incidences).whenComplete(() {
        Fluttertoast.showToast(
            msg: 'Incidence uploaded successfully',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          disastername.text = '';
        });
        toggleLoading();
        print("Incidence uploaded");
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
        msg: e,
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        backgroundColor: Colors.blue,
      );
    }
  }

//function to get image from the admin device
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

//validate inputs
  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate() && _image != null) {
      form.save();
      uploadIncidence(context);
    } else {
      Fluttertoast.showToast(
        msg: 'please select a photo.',
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

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? Builder(
              builder: (context) {
                return Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Post an Incidence to Clients',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: <Widget>[
                            TextFormField(
                              controller: disastername,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  labelText: "disaster name",
                                  helperText: "like road accident."),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "disaster name required";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 300,
                          width: 400,
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.only(right: 4, left: 4),
                            borderOnForeground: true,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 250.0,
                                      child: (_image != null)
                                          ? Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                            )
                                          : Center(
                                              child: Text('Pick an Image'),
                                            ))
                                ],
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
                                getImage();
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
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Upload',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: validateAndSave,
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
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
