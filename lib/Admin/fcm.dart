//firebase
import 'package:firebase_messaging/firebase_messaging.dart';

//flutter
import 'package:flutter/material.dart';

//logic part
class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
         showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(_messageText),
              // title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "My token is: $token"; 
      });
      print(_homeScreenText);
    });
  }

//ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(_messageText),
        ),
      ),
    );
  }
}

// class MessageHandler extends StatefulWidget {
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final Firestore _db = Firestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   StreamSubscription iosSubscription;
//   String btnname = "subscribe";

//   @override
//   void initState() {
//     super.initState();
//         if (Platform.isIOS) {
//             iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//                 // save the token  OR subscribe to a topic here
//                           _saveDeviceToken();

//             });

//             _fcm.requestNotificationPermissions(IosNotificationSettings());
//         }
//         else{
//           _saveDeviceToken();
//         }
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             content: ListTile(
//               title: Text(message['notification']['title']),
//               subtitle: Text(message['notification']['body']),
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Ok'),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           ),
//         );
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");

//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           FlatButton(
//             color: Colors.red,
//             child: Text(btnname),
//             onPressed: () {
//               setState(() {
//                 btnname  = "Subscribed";
//                 _fcm.subscribeToTopic('disasters');
//               });
//             }
//           ),
//           FlatButton(
//             child: Text('Unsubscribe'),
//             onPressed: () => _fcm.unsubscribeFromTopic('disasters'),
//           ),
//         ],
//       ),
//     );
//   }

//   _saveDeviceToken() async {
//     // Get the current user
//     String uid = 'david11';
//     // FirebaseUser user = await _auth.currentUser();

//     // Get the token for this device
//     String fcmToken = await _fcm.getToken();

//     // Save it to Firestore
//     if (fcmToken != null) {
//       var tokens = _db
//           .collection('users')
//           .document(uid)
//           .collection('tokens')
//           .document(fcmToken);

//       await tokens.setData({
//         'token': fcmToken,
//         'createdAt': FieldValue.serverTimestamp(), // optional
//         'platform': Platform.operatingSystem // optional
//       });
//     }
//   }
// }
