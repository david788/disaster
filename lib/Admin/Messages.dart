import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessagingWidget(),
    );
  }
}

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message>messages =[];
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic>message)async{
        print('onMessage: $message');
        final notification = message['notification'];
        setState(() {
          messages.add(Message(title: notification['title'], body: notification['body']));
        });
        
      },
       onLaunch: (Map<String, dynamic>message)async{
        print('onMessage: $message');
      },
       onResume: (Map<String, dynamic>message)async{
        print('onMessage: $message');
      }
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  messages.map(buildmessage).toList(),
   
    );
  
  }
  Widget buildmessage(Message message){
    return ListTile(
      title: Text(message.title),
      subtitle: Text(message.body),
    );
  }
}
class Message{
  final String title;
  final String body;
  const Message({
    @required this.title,
    @required this.body
  });
}