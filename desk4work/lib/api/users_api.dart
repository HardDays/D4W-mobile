import 'dart:async';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';
import 'package:desk4work/model/user.dart';

class UsersApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
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
}