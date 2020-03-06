import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadContacts extends StatefulWidget {
  @override
  _UploadContactsState createState() => _UploadContactsState();
}

class _UploadContactsState extends State<UploadContacts> {
  final formKey = GlobalKey<FormState>();
  var locationcontroller = TextEditingController();
  var contactcontroller = TextEditingController();

  String _contact;
  String _location;
  getContactDetail(_contact) {
    this._contact = _contact;
  }

  getLocationDetail(_location) {
    this._location = _location;
  }

  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void validate() {
    if (formKey.currentState.validate()) {
      // toggleLoading();
      addContact();
    } else {
      Fluttertoast.showToast(
          msg: "all the fields are required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.red,
          fontSize: 20);
    }
  }

  Future<void> addContact() async {
    toggleLoading();

    try {
      DocumentReference documentReference =
          Firestore.instance.collection('contacts').document();
      Map<String, dynamic> contacts = {
        "location": _location,
        "contact": _contact
      };
      documentReference.setData(contacts).whenComplete(() {
        setState(() {
          contactcontroller.text = '';
          locationcontroller.text = '';
        });
        Fluttertoast.showToast(
            msg: "Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
            backgroundColor: Colors.blue);
        toggleLoading();
      });
    } catch (e) {
      toggleLoading();
      Fluttertoast.showToast(
          msg: "$e".toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !loading
            ? Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: formKey,
                      child: ListView(
                        children: <Widget>[
                          Text(
                            'Post help Contact to Clients',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: locationcontroller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "location is required";
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                return _location = value;
                              });
                            },
                            onChanged: (String _location) {
                              getLocationDetail(_location);
                            },
                            decoration: InputDecoration(
                                labelText: "location",
                                helperText: "e.g., Maragua Police "),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: contactcontroller,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "contact is required";
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                return _contact = value;
                              });
                            },
                            onChanged: (String _contact) {
                              getContactDetail(_contact);
                            },
                            decoration: InputDecoration(
                                labelText: "contact",
                                helperText: "e.g., +254720123456"),
                          ),
                          SizedBox(height: 30),
                          CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            child: Text('Add Contact'),
                            onPressed: validate,
                          )
                        ],
                      )),
                ),
              )
            : Center(
                child: CupertinoActivityIndicator(radius: 20),
              ));
  }
}
