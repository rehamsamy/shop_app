
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart 'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/auth_model.dart';
import 'package:shop_app/models/http_exception.dart';

import '../models/auth_model.dart';

class AuthProvider with ChangeNotifier{
static String token;
String userId;
DateTime expireDate;
String _auth_token;


bool get isAuth{
  print(token);
   return token !=null;
}


String get auth_token {
return  _auth_token;
}

  Future authonicated(String email, String password, String type) async {
  try{
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyAUMLLwG2MmqwS2-B_YW4DK02j1OV_Re1I';
    Map<String, Object> map = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    var x=await  http.post(url,body:json.encode(map) );
   // print('11111111  ${map} ------- ${x.body}');
    var response_data=json.decode(x.body);
    if(response_data['error'] !=null){
    throw HttpError(response_data['error']['message']);
    }
     userId=response_data['localId'];
    token=response_data['idToken'];
    _auth_token=response_data['idToken'];
    // expireDate=DateTime.parse(response_data['expiresIn']);
   AuthModel model= AuthModel.fromJson(response_data);
    notifyListeners();
    String user_data=json.encode({'token':model.idToken,'expire':model.expiresIn,'id':model.localId});
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('auth_data',user_data);
    print('dataaa ${prefs.getString('auth_data')} ');
  }catch(e){
    throw e;
  }

}

Future<void> login(String email,String password)async{
  return authonicated(email, password, 'signInWithPassword');
}
Future<void> signup(String email,String password)async{
  return authonicated(email, password, 'signUp');
}



Future<bool> tryAutoLogin()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();

 // String user_data=json.encode({'token':model.idToken,'expire':model.expiresIn,'id':model.localId});

//  AuthModel model= json.decode(prefs.getString('auth_data')) ;
  Map<String,dynamic> map=json.decode(prefs.getString('auth_data')) ;
  if( prefs.getString('auth_data') !=null){
    print('dataaa ${prefs.getString('auth_data')} ');
   return true;
 }if(DateTime.parse(map['expire']).isBefore(DateTime.now())){
     return false;
  }
  notifyListeners();
}



Future<void> logot()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.clear();
  notifyListeners();
}
}