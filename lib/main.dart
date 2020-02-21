import 'package:chap/Admin/AdminHomePage.dart';
import 'package:chap/Authentication.dart';
import 'package:chap/LaunchPage.dart';
import 'package:chap/Login.dart';
import 'package:chap/MappingPage.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  // home: LaunchPage(),
  home: MappingPage(auth: Auth(),),
));


