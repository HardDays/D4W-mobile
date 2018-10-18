import 'dart:async';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class AuthApi{
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const String _loginUrl = ConstantsManager.BASE_URL+"auth/login";
  static const String _usersUrl = ConstantsManager.BASE_URL+ "users/";

  static AuthApi _instance = AuthApi.internal();
  AuthApi.internal();
  factory AuthApi() => _instance;

  Future<Map<String,String>> login(String email, String password){
    Map<String,String> body = {"email": email, "password" : password};
    print('url $_loginUrl');
    print('headers $_headers');

    return _networkUtil.post(_loginUrl,headers: _headers, body: body).then((tokenMaybe){
      if(tokenMaybe!=null && tokenMaybe['token'] !=null)
        return <String,String>{ConstantsManager.TOKEN_KEY : tokenMaybe[ConstantsManager.TOKEN_KEY].toString()};
      return null;
    });
  }

  Future<Map<String,String>> register(String login, String email,
      String phone, String password, String passwordConfirm){
    assert(email !=null && phone != null
        && password !=null && passwordConfirm !=null);

    Map<String, String> body = {ConstantsManager.EMAIL_KEY : email,
      "login" : login, "phone" : phone, "password" : password,
      "password_confirmation" : passwordConfirm};
    return _networkUtil.post(_usersUrl+ "create",headers: _headers, body: body)
        .then((respBody){
      if(respBody !=null && respBody[ConstantsManager.EMAIL_KEY] !=null){
        return {
      ConstantsManager.EMAIL_KEY : email,
      ConstantsManager.FIRST_NAME : login,
      ConstantsManager.PASSWORD_KEY : password };
      }
      return respBody;
    });


  }

  Future<bool> recoverPassword(String phoneOrEmail){
    assert(phoneOrEmail !=null && phoneOrEmail.length >0);
    String url = _usersUrl + "forgot_password";
    return _networkUtil.post(url,body:{ConstantsManager.EMAIL_KEY: phoneOrEmail},
        headers: _headers).then((respBody){
          if(respBody[ConstantsManager.SERVER_ERROR] ==null){
            return true;
          }
          return false;
    });
  }

  Future<bool> checkLogin(String token){
    assert(token !=null);
    String url = _usersUrl +"get_me";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    try{
      return _networkUtil.get(url,headers: _headers).then((respBody){
        if(respBody[ConstantsManager.SERVER_ERROR] == null)
          return true;
        return false;
      });
    }catch(e){
      print('error fetching result : $e');
      return Future.value(false);
    }
  }


  Future<String> vkOrFacebookLogin(String accessToken, bool isFacebook){
    String socialUrl = (isFacebook) ? "facebok" : "vk";
    String url = ConstantsManager.BASE_URL+"auth/$socialUrl";
    Map<String,String> body = {'access_token':accessToken};
    return _networkUtil.post(url, headers: _headers, body: body).then((response){
      if(response!=null && response[ConstantsManager.SERVER_ERROR] == null)
        return response[ConstantsManager.TOKEN_KEY];
    });
  }
}
