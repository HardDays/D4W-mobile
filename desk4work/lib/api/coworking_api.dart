import 'dart:async';

import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:latlong/latlong.dart';

class CoWorkingApi {
  NetworkUtil _networkUtil = NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const _coWorkingUrl = ConstantsManager.BASE_URL + "coworkings/";
  static CoWorkingApi _instance = CoWorkingApi.internal();

  CoWorkingApi.internal();

  factory CoWorkingApi() => _instance;

  Future<List<CoWorking>> searchCoWorkingPlaces(String token, bool paged,
      {LatLng location, Filter filter, int offset = 0}) {
    String stringFilter = "?";
    String latLong;
    Map<String, String> filters = {};
    if (filter != null) {
      String realEndDate;
      if (filter.date != null && filter.date.length == 1) {
        if (filter.startHour != null && filter.endHour != null) {
          int start = int.parse(filter.startHour.substring(0, 2));
          int end = int.parse(filter.startHour.substring(0, 2));
          if (start > end) {
            String fullDate = filter.date[0];
            String year = fullDate.substring(6);
            String month = fullDate.substring(3, 5);
            String day = fullDate.substring(0, 2);

            DateTime dateTime =
                DateTime.parse('$year$month$day').add(Duration(days: 1));

            realEndDate = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
          } else
            realEndDate = filter.date[0];
        } else
          realEndDate = filter.date[0];
      } else if (filter.date != null && filter.date.length > 1) {
        realEndDate = filter.date[1];
      }
      if (filter.place == "Nearby" || filter.place == "Рядом")
        filters['radius'] = '5';
      if (filter.startHour != null) {
        String beginWork = filter.startHour;
        filters['begin_work'] = beginWork;
      }
      if (filter.endHour != null) {
        String endWork = filter.endHour;
        filters['end_work'] = endWork;
      }
      filters.forEach((k, v) {
        stringFilter += '$k=$v&';
      });
      List<String> workingDays = [];
      if (filter.date != null && filter.date.length >= 1) {
        String beginDate = filter.date[0];
        String endDate = realEndDate;
        stringFilter += "begin_date=$beginDate&end_date=$endDate";
      } else {
        DateTime dateTime = DateTime.now();
        stringFilter +=
            'begin_date=${dateTime.day}.${dateTime.month}.${dateTime.year}';
      }

      List<String> amentiesNeeded = [];

      if (filter.parkingNeeded ?? false) {
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=parking');
        amentiesNeeded.add('parking');
      }
      if (filter.freeParkingNeeded ?? false) {
        amentiesNeeded.add('free_parking');
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=free_parking');
      }
      if (filter.freePrinter ?? false) {
        amentiesNeeded.add('free_printing');
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=free_printing');
      }

      if (filter.kitchenNeeded ?? false) {
        amentiesNeeded.add('snacks');
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=snacks');
      }
      if (filter.printerNeeded ?? false) {
        amentiesNeeded.add('printing');
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=printing');
      }
      if (filter.teaOrCoffeeNeeded ?? false) {
        amentiesNeeded.add('coffee');
//        stringFilter += Uri.encodeQueryComponent('&amenties[]=coffee');
      }
      if (amentiesNeeded.length >0)
        stringFilter+= '&amenties='+ amentiesNeeded.join(',');
    }
    if (location != null) {
      double lat = location.latitude;
      double lon = location.longitude;
      latLong = "&lat=$lat&lng=$lon";
      latLong = paged ? latLong : latLong.substring(1);
    }
    String lastParam =
        paged ? "limit=10&offset=$offset${latLong ?? ""}" : '${latLong ?? ""}';

    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url =
        (paged) ? _coWorkingUrl + "get_all_paged" : _coWorkingUrl + 'get_all';
//    url +="?limit=10";
    url = (stringFilter == null && stringFilter.length > 1)
        ? url + "?$lastParam"
        : url + stringFilter + "&$lastParam";

    print('coworking url $url');
    return _networkUtil.get(url, headers: _headers).then((responseBody) {
      List<CoWorking> coWorkings = [];

      if (!(responseBody is List) &&
          responseBody[ConstantsManager.SERVER_ERROR] != null) {
        return coWorkings;
      }
      var respBody =
          (responseBody is List) ? responseBody : responseBody['coworkings'];

      respBody.forEach((coWorking) {
        CoWorking cw = CoWorking.fromJson(coWorking);
        coWorkings.add(cw);
      });
      return coWorkings;
    });
  }

  Future<CoWorking> getCoWorking(String token, int id) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl + "get/$id";
    return _networkUtil.get(url, headers: _headers).then((responseBody) {
      CoWorking coWorking;
      coWorking = CoWorking.fromJson(responseBody);
      return getFreeSeat(token, id)
          .then((freeSeats) => coWorking.freeSeats = freeSeats)
          .then((_) {
        return coWorking;
      });
//      return coWorking;
    });
  }

  Future<int> getFreeSeat(String token, int id, {DateTime start, end}) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _coWorkingUrl + "get_free_seats/$id";
    return _networkUtil.get(url, headers: _headers).then((response) {
      return response['free_seats'];
    });
  }
}
