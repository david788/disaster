//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//logic part
class AdvicePage extends StatefulWidget {
  @override
  _AdvicePageState createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _advice = [];
  bool _loadingAdvice = true;
  int _perPage = 5;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();
  bool _gettingMoreAdvice = false;
  bool _moreAdviceAvailable = true;

//pagination starts
//function to retrieve advice content from the firestore
  _getAdvice() async {
    Query q = _firestore
        .collection("advice")
        .orderBy('timestamp', descending: true)
        .limit(_perPage);
    setState(() {
      _loadingAdvice = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    _advice = querySnapshot.documents;
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    setState(() {
      _loadingAdvice = false;
    });
  }

//function called when the user scrolls to get more advice content displayed
  _getMoreAdvice() async {
    print("get more advice called");
    if (_moreAdviceAvailable == false) {
      print("no more advice");
      return;
    }
    if (_gettingMoreAdvice == true) {
      return;
    }
    _gettingMoreAdvice = true;
    Query q = _firestore
        .collection("advice")
        .orderBy('timestamp', descending: true)
        .startAfter([_lastDocument.data['timestamp']]).limit(_perPage);

    QuerySnapshot querySnapshot = await q.getDocuments();
    if (querySnapshot.documents.length < _perPage) {
      _moreAdviceAvailable = false;
    }
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    _advice.addAll(querySnapshot.documents);
    setState(() {});
    _gettingMoreAdvice = false;
  }

//in the initial state, the first perpage advice content is loaded. then scroller is activated to listen to the user scrolls
  @override
  void initState() {
    super.initState();
    _getAdvice();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        _getMoreAdvice();
      }
    });
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Advice Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: !_loadingAdvice
          ? Container(
              child: _advice.length == 0
                  ? Center(
                      child: Text('no new advice'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _advice.length,
                      itemBuilder: (BuildContext context, int index) {
                        String time = _advice[index].data['time'].toString();
                        String date = _advice[index].data['date'].toString();

                        String title = _advice[index].data['title'].toString();

                        String content =
                            _advice[index].data['content'].toString();

                        return Card(
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ListTile(
                                leading: Text(date),
                                trailing: Text(time),
                              ),
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    content,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          : Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            ),
    );
  }
}
