//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//logic
class UploadAdvicePge extends StatefulWidget {
  @override
  _UploadAdvicePgeState createState() => _UploadAdvicePgeState();
}

class _UploadAdvicePgeState extends State<UploadAdvicePge> {
  final formKey = GlobalKey<FormState>();
  var advicecontroller = TextEditingController();
  var titlecontroller = TextEditingController();

  String _title, _advice;
  getTitle(_title) {
    this._title = _title;
  }

  getAdvice(_advice) {
    this._advice = _advice;
  }

//loading spinner
  bool loading = false;
  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  //dialog for the admin to confirm upload of content
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.warning),
                Text(
                  'Update Advice?',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  uploadAdvice();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//the function to upload the advice content to firestore
  Future<void> uploadAdvice() async {
    toggleLoading();

    try {
      var dbTimeKey = DateTime.now();

      var formatDate = DateFormat('MMM d, yyyy');
      var formatTime = DateFormat('EEEE, hh:mm aaa');

      String date = formatDate.format(dbTimeKey);
      String time = formatTime.format(dbTimeKey);
      DocumentReference documentReference =
          Firestore.instance.collection('advice').document();
      Map<String, dynamic> advice = {
        "time": time,
        "date": date,
        "timestamp": dbTimeKey,
        "title": _title,
        "content": _advice,
      };
      documentReference.setData(advice).whenComplete(() {
        setState(() {
          titlecontroller.text = '';
          advicecontroller.text = '';
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

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Post an advice to Clients',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: titlecontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "title required";
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            return _title = value;
                          });
                        },
                        onChanged: (String _title) {
                          getTitle(_title);
                        },
                        decoration: InputDecoration(
                            labelText: "Title",
                            helperText: "e.g., How to Handle Fire..."),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: advicecontroller,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "advice content required";
                                } else
                                  return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  return _advice = value;
                                });
                              },
                              onChanged: (String _advice) {
                                getAdvice(_advice);
                              },
                              decoration: InputDecoration(
                                  labelText: "Enter the content here",
                                  helperText: "e.g., Step 1: do this..."),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      CupertinoButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: validate),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(
              radius: 20,
            )),
    );
  }

  void validate() {
    if (formKey.currentState.validate()) {
      createAlertDialog(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Please fill all the details',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
