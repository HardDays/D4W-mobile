import 'dart:async';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class AuthApi{
  NetworkUtil _networkUtil = NetworkUtil();
  static const String _loginUrl = ConstantsManager.BASE_URL+"/auth/login";
  static const String _authenticationUrl = "";
  Map<String, String> _headers;

  static AuthApi _instance = AuthApi.internal();
  AuthApi.internal();
  factory AuthApi() => _instance;

  Future<Map<String,String>> login(String email, String password){
    Map<String,String> body = {"email": email, "password" : password};
    return _networkUtil.post(_loginUrl,body: body).then((tokenMaybe){
      if(tokenMaybe!=null && tokenMaybe['token'] !=null)
        return tokenMaybe['token'];
      else return {"error" : "401"};
    });
  }
}