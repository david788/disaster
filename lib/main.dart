import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'MappingPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('useremail');
  print(email);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? LoginPage() : MappingPage(),
    theme: ThemeData(primaryColor: Colors.cyan, primarySwatch: Colors.cyan),
  ));
}
