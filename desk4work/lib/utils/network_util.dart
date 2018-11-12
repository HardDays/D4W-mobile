import 'dart:async';
import 'dart:convert';
import 'package:desk4work/utils/constants.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print('status code: $statusCode');
      if (statusCode < 200 || statusCode > 400) {
        print("raw response ${response.reasonPhrase}");
        print("headers : ${response.toString()}");
        return {ConstantsManager.SERVER_ERROR: statusCode};
//        throw new Exception("Error while fetching data");
      }
      if (json == null) return null;
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      print('post response url ${url}');
      print('post response headers ${response.headers}');
      print('post response status ${response.statusCode}');
      print('post response body ${response.body}');
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        //        throw new Exception(res);
        return {ConstantsManager.SERVER_ERROR: statusCode, 'body' : res};
      }
      if (json == null) return null;
      try {
        return _decoder.convert(res);
      } catch (e) {
        print('response body parse error: e');
        return res;
      }
    });
  }

  Future<dynamic> put(String url, {Map headers, body, encoding}) {
    return http
        .put(url, body: json.encode(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      print('put response url ${url}');
      print('put response headers ${response.headers}');
      print('put response status ${response.statusCode}');
      print('put response body ${response.body}');
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        //        throw new Exception(res);
        return {ConstantsManager.SERVER_ERROR: statusCode, 'body' : res};
      }
      if (json == null) return null;
      return _decoder.convert(res);
    });
  }
}
