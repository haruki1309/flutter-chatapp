import 'package:appchat/src/resources/chatscreen.dart';
import 'package:appchat/src/resources/home_page.dart';
import 'package:appchat/src/resources/login_page.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(home: LoginPage());
  }
}