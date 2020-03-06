import 'package:chap/TabFiles/DisasterSpecificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'DisasterDetails.dart';

class DisasterPage extends StatefulWidget {
  @override
  _DisasterPageState createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: Builder(builder: (context) {
        return Container(
          child: ListView(
            padding: EdgeInsets.only(left: 20),
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(right: 15),
                width: MediaQuery.of(context).size.width - 30,
                // height: MediaQuery.of(context).size.height -50,
                height: 800,
                child: GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: <Widget>[
                    _buildCard(
                        'Road Accident', "images/accident.png", true, context),
                    _buildCard('Need Ambulance', "images/ambulance.png", true,
                        context),
                    _buildCard(
                        'Drowning', "images/drowning.png", true, context),
                    _buildCard(
                        'Fire Outbreak', "images/fire.png", true, context),
                    _buildCard('Collapsing Building', "images/collapse.png",
                        true, context),
                    _buildCard(
                        'Land SLide', "images/landslide.png", true, context),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(right:16, left:8),
                child: FlatButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DisasterSpecificationPage()));
                },
                color: Colors.blue,
                 child: Text("any other type of incidence..? click here", style: TextStyle(color: Colors.white),)),
              ),
              SizedBox(height:20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(String name, String imgPath, bool isFavorite, context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DisasterDetail(assetPath: imgPath, disasterName: name)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    isFavorite
                        ? Icon(Icons.verified_user, color: Colors.blueAccent)
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                  ],
                ),
              ),
              Hero(
                tag: imgPath,
                child: Container(
                  height: 100,
                  width: 75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imgPath), fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Text(name,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: Color(0xFFEBEBEB),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
