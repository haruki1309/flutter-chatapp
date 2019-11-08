
class Validations{
  static bool isValidUsername(String username){
    return username !=  null && username.length > 6;
  }

  static bool isValidEmail(String email){
    return email !=  null && email.length > 6 && email.contains("@");
  }

  static bool isValidPassword(String password){
    return password !=  null && password.length > 6;
  }
}