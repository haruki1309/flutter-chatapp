import 'package:flutter/material.dart';

class MessageDialog{
  static void showMessageDialog(BuildContext context, String title, String msg){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: (){
            Navigator.of(context).pop(MessageDialog);
          },
        )
      ],
    ));
  }
}