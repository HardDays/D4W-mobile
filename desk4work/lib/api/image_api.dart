import 'dart:async';

import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class ImageApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json', 'Content-type': 'application/json'};
  static const String _imagesUrl = ConstantsManager.BASE_URL+ "images/get_full/";

  static ImageApi _instance = ImageApi.internal();
  ImageApi.internal();
  factory ImageApi() => _instance;

  Future<String> getImage(String token, int id){
    String url = _imagesUrl+'$id';
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    print(' url $url');
    return _networkUtil.get(url, headers: _headers).then((picture){
      print("picture result ${picture.runtimeType}");
//      print("picture result $picture");
    });
  }
}