import 'package:appchat/src/blocs/login_signin_bloc.dart';
import 'package:appchat/src/resources/chatscreen.dart';
import 'package:appchat/src/resources/dialogs/loading_dialog.dart';
import 'package:appchat/src/resources/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget{
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>{
  bool _isShowPass = false;
  bool _isShowConfirmPass = false;

  LoginSigninBloc bloc = new LoginSigninBloc();
  
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                //username field
                StreamBuilder(
                  stream: bloc.usernameStream,
                  builder: (context, snapshot)=>TextField(
                    controller: _usernameController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "USERNAME",
                      errorText: snapshot.hasError? snapshot.error : null,
                      labelStyle: TextStyle(color: Color(0xff888888), fontSize: 14)
                    ),
                  )
                ),

                SizedBox(
                  height: 30,
                ),

                //email field
                StreamBuilder(
                  stream: bloc.emailStream,
                  builder: (context, snapshot)=>TextField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "EMAIL",
                      errorText: snapshot.hasError? snapshot.error : null,
                      labelStyle: TextStyle(color: Color(0xff888888), fontSize: 14)
                    ),
                  )
                ),

                SizedBox(
                  height: 30,
                ),

                //password field
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    StreamBuilder(
                      stream: bloc.passwordStream, 
                      builder: (context, snapshot)=>TextField(
                        controller: _passwordController,
                        obscureText: !_isShowPass,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "PASSWORD",
                          errorText: snapshot.hasError? snapshot.error : null,
                          labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)
                        ),
                      )
                    ),

                    GestureDetector(
                      onTap: onToggleShowPass,
                      child: Text(
                        _isShowPass ? "HIDE":"SHOW", 
                        style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold)
                      )
                    )
                  ],
                ),

                SizedBox(
                  height: 30,
                ),

                //Confirm Password field
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    StreamBuilder(
                      stream: bloc.confirmPasswordStream, 
                      builder: (context, snapshot)=>TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isShowConfirmPass,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "CONFIRM PASSWORD",
                          errorText: snapshot.hasError? snapshot.error : null,
                          labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)
                        ),
                      )
                    ),

                    GestureDetector(
                      onTap: onToggleShowConfirmPass,
                      child: Text(
                        _isShowConfirmPass ? "HIDE":"SHOW", 
                        style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold)
                      )
                    )
                  ],
                ),

                 Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: RaisedButton(
                      onPressed: onRegisterClicked,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      color: Colors.blue,
                      child: Text("REGISTER", style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),
                ),
              ],
            )
          ),
        )
      )
    );
  }



  void onRegisterClicked(){
    if(bloc.isValidRegister(_usernameController.text, _emailController.text, _passwordController.text, _confirmPasswordController.text))
    {
      //loading dialog
      LoadingDialog.showLoadingDialog(context, "Loading...");

      bloc.register(_usernameController.text, _emailController.text, _passwordController.text, (){
        LoadingDialog.hideLoadingDialog(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatpage()));
      }, (msg){
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Register Problem", msg);
      });   
    }
  }

  void onToggleShowPass(){
    setState(() {
      _isShowPass = !_isShowPass; 
    });
  }

  void onToggleShowConfirmPass(){
    setState(() {
      _isShowConfirmPass = !_isShowConfirmPass; 
    });
  }
}