import 'dart:async';
import 'package:appchat/src/fire_base/fire_base_auth.dart';
import 'package:appchat/src/validators/validations.dart';

class LoginSigninBloc{
  var firebaseAuth = FireAuth();

  StreamController _usernameController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _passwordController = new StreamController();
  StreamController _confirmPasswordController = new StreamController();

  Stream get usernameStream => _usernameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get confirmPasswordStream => _confirmPasswordController.stream;

  bool isValidLogin(String email, String password){
    if(!Validations.isValidEmail(email)){
      _emailController.sink.addError("EMAIL không hợp lệ");
      return false;
    }
    _emailController.sink.add("OK");

    if(!Validations.isValidPassword(password)){
      _passwordController.sink.addError("PASSWORD phải trên 6 kí tự");
      return false;
    }
    _passwordController.sink.add("OK");
    
    return true;
  }

  bool isValidRegister(String username, String email, String password, String confirmPassword){
    if(!Validations.isValidUsername(username)){
      _usernameController.sink.addError("USERNAME không hợp lệ");
      return false;
    }
    _usernameController.sink.add("OK");

    if(!Validations.isValidEmail(email)){
      _emailController.sink.addError("EMAIL không hợp lệ");
      return false;
    }
    _emailController.sink.add("OK");

    if(!Validations.isValidPassword(password)){
      _passwordController.sink.addError("PASSWORD phải trên 6 kí tự");
      return false;
    }
    _passwordController.sink.add("OK");

    if(password != confirmPassword){
      _confirmPasswordController.sink.addError("PASSWORD không trùng khớp");
      return false;
    }
    _confirmPasswordController.sink.add("OK");

    return true;
  }

  void register(String username, String email, String password, Function onSuccess, Function(String) onRegisterError){
    firebaseAuth.register(username, email, password, onSuccess, onRegisterError);
  }

  void login(String email, String password, Function onSuccess, Function(String) onLoginError){
    firebaseAuth.login(email, password, onSuccess, onLoginError);
  }

  void dispose(){
    _usernameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
}