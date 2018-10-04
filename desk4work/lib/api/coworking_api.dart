import 'dart:async';

import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';

class CoWorkingApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const _coWorkingUrl = ConstantsManager.BASE_URL+ "coworkings/";
  static CoWorkingApi _instance = CoWorkingApi.internal();
  CoWorkingApi.internal();
  factory CoWorkingApi() => _instance;

  Future<List<CoWorking>> searchCoWorkingPlaces(String token, {Filter filter}){
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl+ "get_all_paged";
    url +="?limit=10";
    return _networkUtil.get(url, headers: _headers).then((responseBody){
      List<CoWorking> coWorkings = [];

      responseBody['coworkings'].forEach((coWorking){
        print("coworking: $coWorking");
        coWorkings.add(CoWorking.fromJson(coWorking));
      });
     return coWorkings;
    });
  }

  Future<CoWorking> getCoWorking(String token, int id){
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl+ "get/$id";
    return _networkUtil.get(url, headers: _headers).then((responseBody){
      CoWorking coWorking;

      coWorking = responseBody['coworking'];
      return coWorking;
    });
  }


}