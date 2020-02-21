import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireMap(),
    );
  }
}

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location location = Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              // CameraPosition(target: LatLng(24.142, -110.321), zoom: 15),
              CameraPosition(target: LatLng(37.147424, -0.714098), zoom: 15),
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
        ),
        Positioned(
            bottom: 50,
            right: 10,
            child: FlatButton(
                onPressed: _addGeoPoint,
                child: Icon(
                  Icons.pin_drop,
                  color: Colors.white,
                  size: 40,
                )))
      ],
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addMarker() {
    // var marker = MarkerOptions(
    var marker = Marker(
        markerId: null,
        // position: mapController.moveCamera(cameraUpdate),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow.noText);
      // mapController.addMarker();
  }
  _animateToUser()async{
     var pos = await location.getLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(pos.latitude, pos.latitude),
          zoom: 17.0,
        )
      )
    );
  }

Future<DocumentReference> _addGeoPoint() async {
 try{
    var pos = await location.getLocation();
  GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
  return firestore.collection('disasters').add({ 
    'position': point.data,
  });
 }catch(e){
   Fluttertoast.showToast(msg: e.toString());
 }
}
}
