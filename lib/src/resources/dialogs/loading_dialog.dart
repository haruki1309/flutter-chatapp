import 'package:flutter/material.dart';

class LoadingDialog{
  static void showLoadingDialog(BuildContext context, String msg){
    showDialog(context: context, barrierDismissible: false, 
      builder: (context)=>new Dialog(
        child: Container(
          height: 240,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(msg, style: TextStyle(fontSize: 14)),
              )
            ],
          ),
        ),
      )
    );
  }

  static void hideLoadingDialog(BuildContext context){
    Navigator.of(context).pop(LoadingDialog);
  }
}