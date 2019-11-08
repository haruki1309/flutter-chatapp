import 'package:appchat/src/blocs/login_signin_bloc.dart';
import 'package:appchat/src/resources/chatscreen.dart';
import 'package:appchat/src/resources/dialogs/loading_dialog.dart';
import 'package:appchat/src/resources/dialogs/message_dialog.dart';
import 'package:appchat/src/resources/register_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  LoginSigninBloc bloc = new LoginSigninBloc();
  bool _isShowPass = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

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

                //username field
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 30),
                  child: StreamBuilder(
                    stream: bloc.emailStream,
                    builder: (context, snapshot)=>TextField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "USERNAME",
                        errorText: snapshot.hasError? snapshot.error : null,
                        labelStyle: TextStyle(color: Color(0xff888888), fontSize: 14)
                      ),
                    )
                  ),
                ),

                //password field
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Stack(
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
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: RaisedButton(
                      onPressed: onLoginClicked,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      color: Colors.blue,
                      child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: GestureDetector(
                    onTap: onRegisterClicked,
                    child: Text("REGISTER NOW!", style: TextStyle(fontSize: 14, color: Colors.blue)),
                  ),
                ),
              ],
            )
          ),
        )
      )
    );
  }

  void onLoginClicked(){
    if(bloc.isValidLogin(_emailController.text, _passwordController.text)){
      LoadingDialog.showLoadingDialog(context, "Loading...");

      bloc.login(_emailController.text, _passwordController.text, (){
        LoadingDialog.hideLoadingDialog(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatpage()));
      }, (msg){
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMessageDialog(context, "Login", msg);
      });
      
    }
  }

  void onRegisterClicked(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
  }

  void onToggleShowPass(){
    setState(() {
      _isShowPass = !_isShowPass; 
    });
  }
}