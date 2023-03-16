import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mark/utility/jwt.dart';
import 'package:mark/models/user.dart';

abstract class BaseAuth {
  Future<dynamic> signUp(Map<String,dynamic> user);

  Future<dynamic> getCurrentUser();

  Future<dynamic> signOut();

  Future<dynamic> sendotp(String phone);

  Future<dynamic> signInWithOTP(String phone, String verificationId);

  Future<dynamic> signInWithEmail(String email, String password);
}

class Auth implements BaseAuth {
  String Token;
  String uploadURL = 'http://127.0.0.1:5000';
  JWT jwt= JWT();


  Future<dynamic> signUp(Map<String,dynamic> user) async{
    String URL = uploadURL+'/register/';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(user),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
      return responseData['username'];
      }
      else{
        return '';
      }
    } catch (e) {
      print(e);
       return '';
    }
  }

  Future<dynamic> getCurrentUser() async {
    Token = await jwt.read_token();
    print(Token);
    if(Token == null){
      return null;
    }
    String URL = uploadURL+'/currentuser';
    final response = await http.get(URL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    try {
      var responseData = json.decode(response.body);
      User user = User.fromMap(responseData);//list, alternative empty string " "
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await jwt.delete_token();
  }


  Future<dynamic> signInWithEmail(String email, String password) async{
    String URL = uploadURL+'/login';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'email':email,'password':password}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        await jwt.store_token(responseData['token']);
        return responseData['status'];
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> signInWithOTP(String phone, String verificationId) async{
    String URL = uploadURL+'/register/';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'phonenumber':phone,'verification-code':verificationId}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        await jwt.store_token(responseData['token']);
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> sendotp(String phone) async{
    String URL = uploadURL+'/getOTP';
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String,String>{'phonenumber':phone}),
      );
      var responseData = json.decode(response.body);
      if(responseData['status']){
        return responseData['code'];
      }
      else{
        return '';
      }
    } catch (e) {
      return '';
    }
  }



}
