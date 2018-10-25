import 'dart:async';
import 'dart:convert';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class AuthApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const String _loginUrl = ConstantsManager.BASE_URL + "auth/login";
  static const String _usersUrl = ConstantsManager.BASE_URL + "users/";

  static AuthApi _instance = AuthApi.internal();

  AuthApi.internal();

  factory AuthApi() => _instance;

  Future<Map<String, String>> login(String email, String password) {
    Map<String, String> body = {"email": email, "password": password};
    _headers = {};
    _headers = {'Accept': 'application/json'};
    print('url $_loginUrl');
    print('headers $_headers');

    return _networkUtil
        .post(_loginUrl, headers: _headers, body: body)
        .then((tokenMaybe) {
      if (tokenMaybe != null) if (tokenMaybe['token'] != null) {
        return <String, String>{
          ConstantsManager.TOKEN_KEY:
              tokenMaybe[ConstantsManager.TOKEN_KEY].toString()
        };
      } else if (tokenMaybe[ConstantsManager.SERVER_ERROR] != null)
        return <String, String>{
          ConstantsManager.SERVER_ERROR:
              tokenMaybe[ConstantsManager.SERVER_ERROR].toString()
        };
      return null;
    });
  }

  Future<Map<String, String>> register(String login, String email, String phone,
      String password, String passwordConfirm) {
    assert(email != null &&
        phone != null &&
        password != null &&
        passwordConfirm != null);

    Map<String, String> body = {
      ConstantsManager.EMAIL_KEY: email,
      "login": login,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirm
    };
    return _networkUtil
        .post(_usersUrl + "create", headers: _headers, body: body)
        .then((respBody) {
      if (respBody != null && respBody[ConstantsManager.EMAIL_KEY] != null) {
        return {
          ConstantsManager.EMAIL_KEY: email,
          ConstantsManager.FIRST_NAME: login,
          ConstantsManager.PASSWORD_KEY: password
        };
      } else if (respBody != null) {
        JsonDecoder _decoder = JsonDecoder();
        Map<String, dynamic> emailError = _decoder.convert(respBody['body']);
        print('type of thisiiiisss: ${emailError["email"].runtimeType}');
        print('type of thisiiiisss: ${emailError["email"]}');
        if (respBody[ConstantsManager.SERVER_ERROR] == 422 &&
            emailError["email"] != null &&
            emailError["email"][0] == 'ALREADY_TAKEN') {
          return {ConstantsManager.SERVER_ERROR : 'ALREADY_TAKEN'};
        }
      }
      return null;
    });
  }

  Future<Map<String, dynamic>> recoverPassword(String phoneOrEmail) {
    assert(phoneOrEmail != null && phoneOrEmail.length > 0);
    String url = _usersUrl + "forgot_password";
    return _networkUtil
        .post(url,
            body: {ConstantsManager.EMAIL_KEY: phoneOrEmail}, headers: _headers)
        .then((respBody) {
      print('recover password response ${respBody}');
      if (respBody != null &&
          (respBody.runtimeType == String ||
              respBody[ConstantsManager.SERVER_ERROR] == null)) {
        return {ConstantsManager.SERVER_ERROR: null};
      } else if (respBody[ConstantsManager.SERVER_ERROR] != null)
        return respBody;
      return {ConstantsManager.SERVER_ERROR: ConstantsManager.SERVER_ERROR};
    });
  }

  Future checkLogin(String token) {
    assert(token != null);
    String url = _usersUrl + "get_me";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    try {
      return _networkUtil.get(url, headers: _headers).then((respBody) {
        if (respBody[ConstantsManager.SERVER_ERROR] == null) return true;
        return false;
      }).catchError((e) {
        return e;
      });
    } catch (e) {
      print('error fetching result : $e');
      return e;
    }
  }

  Future<String> vkOrFacebookLogin(String accessToken, bool isFacebook) {
    String socialUrl = (isFacebook) ? "facebok" : "vk";
    String url = ConstantsManager.BASE_URL + "auth/$socialUrl";
    Map<String, String> body = {'access_token': accessToken};
    return _networkUtil
        .post(url, headers: _headers, body: body)
        .then((response) {
      if (response != null && response[ConstantsManager.SERVER_ERROR] == null)
        return response[ConstantsManager.TOKEN_KEY];
    });
  }
}
