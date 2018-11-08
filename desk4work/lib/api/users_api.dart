import 'dart:async';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';
import 'package:desk4work/model/user.dart';

class UsersApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json', 'Content-type': 'application/json'};
  static const String _usersUrl = ConstantsManager.BASE_URL+ "users/";

  static UsersApi _instance = UsersApi.internal();
  UsersApi.internal();
  factory UsersApi() => _instance;

  Future<User> getMe(String token){
    assert(token !=null);
    String url = _usersUrl +"get_me";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url,headers: _headers).then((respBody){
      return User.fromJson(respBody);
    });
  }
  
  Future<User> updateMe(String token, User user){
    assert(token !=null);
    assert(user !=null);
    String url = _usersUrl +"update_me";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.put(url, headers: _headers, body: user.toJson()).then((respBody){
      return User.fromJson(respBody);
    });
  }

  Future<bool> changePassword(String token, String oldPassword, String newPassword, String newPasswordConfirm){
    assert(token !=null);
    assert(oldPassword !=null);
    assert(newPassword !=null);
    assert(newPasswordConfirm !=null);

    String url = _usersUrl + "change_password";
    Map<String,String> head = {'Accept': 'application/json'};
    head[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.post(url, headers: head, body: {'old_password': oldPassword, 'password': newPassword, 'password_confirmation': newPasswordConfirm}).then((respBody){
      return respBody['status'] != null;
    });
  }


}