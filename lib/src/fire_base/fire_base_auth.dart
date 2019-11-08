import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireAuth{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void register(String username, String email, String password, Function onSuccess, Function(String) onRegisterError){
    _firebaseAuth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((user){
        _createUser(user.user.uid, username, onSuccess, onRegisterError);
      })
      .catchError((err){
        _onRegisterError(err.code, onRegisterError);
    });
  }

  void login(String email, String password, Function onSuccess, Function(String) onLoginError){

    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
    .then((user){
      onSuccess();
    })
    .catchError((error){
      print(error);
      onLoginError("Login faild, please try again");
    });
  }

  _createUser(String userId, String username, Function onSuccess, Function(String) onRegisterError){
    var user = {
      "username" : username,
    };
    var ref = FirebaseDatabase.instance.reference().child("users");

    ref.child(userId).set(user).then((user) {
      onSuccess();
    }).catchError((error){
      onRegisterError("Register fail, please try again");
    });
  }

  void _onRegisterError(String code, Function(String) onRegisterError){
    switch(code){
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("Password is not strong enough");
        break;
      default:
        onRegisterError("Register fail, please try again");
        break;
    }
  }
}