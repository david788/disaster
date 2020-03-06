import 'package:chap/Authentication.dart';
import 'package:chap/MappingPage.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  // home: AdminHomePage(),
  home: MappingPage(auth: Auth(),),

));


