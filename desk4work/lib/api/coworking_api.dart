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

  Future<List<CoWorking>> searchCoWorkingPlaces  (String token, {Filter filter}) {

    print('filter settings : $filter');
    String stringFilter;
    if(filter != null) {
      String beginWork = filter.startHour;
      String endWork = filter.endHour;
      List<String> workingDays= [];
      String beginDate = filter.date[0];
      String endDate = filter.date[1];
      stringFilter = "?begin_work=$beginWork&end_work=$endWork"
          "&begin_date=$beginDate&end_date=$endDate";
      if(filter.conferenceRoomNeeded ?? false)
        stringFilter+= Uri.encodeQueryComponent('&ementies[]=conference_room');
      if(filter.kitchenNeeded ?? false)
              stringFilter+= Uri.encodeQueryComponent('&ementies[]=kitchen');
      if(filter.printerNeeded ?? false)
              stringFilter+= Uri.encodeQueryComponent('&ementies[]=printing');
      if(filter.teaOrCoffeeNeeded ?? false)
        stringFilter+= Uri.encodeQueryComponent('&ementies[]=coffee');
      if(filter.parkForBicycleNeeded ?? false)
        stringFilter+= Uri.encodeQueryComponent('&ementies[]=bike_storage');

    }
//      limit=10&offset=10&creator_id=1&full_name=aaa&description=bbb
//      &address=ccc&additional_info=ddd&begin_work=10:20&end_work=15:30
//    &working_days[]=Monday&working_days[]=Sunday&free=true
//    &begin_date=25.01.1994&end_date=25.01.1994&lat=10.2&lng=20.3&radius=1
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl+ "get_all_paged";
//    url +="?limit=10";
    url=(stringFilter==null) ? url+"?limit=10" : url+stringFilter+"&limit=10";
    return _networkUtil.get(url, headers: _headers).then((responseBody){
      print("urllllll $url");
      List<CoWorking> coWorkings = [];

      responseBody['coworkings'].forEach((coWorking){
        CoWorking cw = CoWorking.fromJson(coWorking);
        coWorkings.add(cw);

      });
     return coWorkings;
    });
  }

  Future<CoWorking> getCoWorking(String token, int id){
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl+ "get/$id";
    return _networkUtil.get(url, headers: _headers).then((responseBody){
      CoWorking coWorking;
      coWorking = CoWorking.fromJson(responseBody);
      return getFreeSeat(token, id)
          .then((freeSeats) => coWorking.freeSeats = freeSeats).then((_){
            return coWorking;
      });
//      return coWorking;
    });
  }

  Future<int> getFreeSeat(String token, int id,{DateTime start, end}){
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl+"get_free_seats/$id";
    print('url $url');
    return _networkUtil.get(url, headers: _headers).then((response){
      return response['free_seats'];
    });

  }




}