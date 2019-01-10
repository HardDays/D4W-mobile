import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class BookingApi {
  NetworkUtil _networkUtil = new NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const _bookingUrl = ConstantsManager.BASE_URL + "bookings/";
  static BookingApi _instance = BookingApi.internal();

  BookingApi.internal();

  factory BookingApi() => _instance;

  Future<List<Booking>> getUserBookings(String token) {
    DateTime now = DateTime.now();
//    int day = now.day;
//    int month = now.month;
//    int year = now.year;
//    String date = '$day.$month.$year';
//    String url = ConstantsManager.BASE_URL + "users/get_my_bookings?date=$date";
    String url = ConstantsManager.BASE_URL + "users/get_my_bookings";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url, headers: _headers).then((response) {
      List<Booking> bookings = [];
      response.forEach((r) {
        Booking b = Booking.fromJson(r);
        bookings.add(b);
      });
      return bookings;
    });
  }


  Future<List<Booking>> getPastBookings(String token, {DateTime date}) {
    String url = ConstantsManager.BASE_URL + "users/get_past_bookings";
    if (date != null) {
      url += '?date=' + DateFormat.yMd().format(date);
    }
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url, headers: _headers).then((response) {
      List<Booking> bookings = [];
      response.forEach((b) {
        bookings.add(Booking.fromJson(b));
      });
      return bookings;
    });
  }

  Future<Booking> book(String token, int coWorkingId, int numberOfSeats,
      String startHour, endHour, String date) {
    int year = int.parse(date.substring(0, 4));
    String monthDay = date.substring(5);
    String month = monthDay.substring(0, monthDay.indexOf('-'));
    month = month.length < 2 ? '0'+month : month;
    String day =monthDay.substring(monthDay.indexOf('-')+1);
    day = day.length < 2 ? '0'+day : day;
    date = '$year-$month-$day';
    int startTime = int.parse(startHour.substring(0,startHour.indexOf(':')));
    int endTime = int.parse(endHour.substring(0,endHour.indexOf(':')));
    print('date final: $date');
    startHour = (startHour.length > 1) ? startHour : '0$startHour';
    DateTime startDateTime = DateTime.parse("$date $startHour:00");
    startDateTime = startDateTime.subtract(DateTime.now().timeZoneOffset);

    String startDate = startDateTime.toIso8601String();

//    String startDate = date + "T" + startHour;
//    String endDate = date + "T" + endHour;
    endHour = (endHour.length > 1) ? endHour : '0$endHour';
    DateTime endDateTime = DateTime.parse("$date $endHour:00");
    if(endTime < startTime){
      endDateTime.add(Duration(days: 1));
//      String year = date.substring(0,4);
//      String month = (date.substring(6).startsWith('-')) ? date.substring(5,6) : date.substring(5,7);
//      month = (int.parse(month) > 9) ? month : "0"+month;
//      String day = (date.substring(6).startsWith('-')) ? date.substring(7) : date.substring(8);
//      day = (int.parse(day) > 9) ? day : "0"+day;
//      endDateTime = DateTime.parse('$year$month$day').add(Duration(days: 1));
//      endDate = '${endDateTime.year}-${endDateTime.month}-${endDateTime.day}T$endHour';

    }
    endDateTime = endDateTime.subtract(DateTime.now().timeZoneOffset);
    String endDate = endDateTime.toIso8601String();
    String url = ConstantsManager.BASE_URL + "bookings/create";

    _headers[ConstantsManager.TOKEN_HEADER] = token;
    Map<String, String> body = {
      ConstantsManager.CO_WORKING_ID: coWorkingId.toString(),
      ConstantsManager.VISITORS_COUNT: numberOfSeats.toString(),
      ConstantsManager.BEGIN_DATE: startDate,
      ConstantsManager.END_DATE: endDate
    };

//   TODO: deal with errors 422 and show message

    return _networkUtil
        .post(url, headers: _headers, body: body)
        .then((serverResponse) {

      int statusCode = serverResponse[ConstantsManager.SERVER_ERROR];
      if (statusCode != null) {
        if (statusCode == 422) {
          var errorBody = serverResponse['body'];
          JsonDecoder jsonDecoder = JsonDecoder();
          errorBody = jsonDecoder.convert(errorBody);
          if (errorBody != null) throw ArgumentError([errorBody]);
        }
      }
      return Booking.fromJson(serverResponse);
    });
  }

  Future<Map<String, dynamic>> confirmVisit(String token, int bookingId) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl + 'confirm_visit';
    Map<String, String> body = {
      ConstantsManager.BOOKING_ID: bookingId.toString()
    };
    return _networkUtil.post(url, headers: _headers, body: body).then((res) {
      if(res!=null && res[ConstantsManager.SERVER_ERROR] == null){
        return {"booking" : Booking.fromJson(res)};
      }else if(res !=null && res[ConstantsManager.SERVER_ERROR] !=null){
        return res;
      }
      else{
        return null;
      }
    });
  }

  Future<Map<String, dynamic>> confirmFinish(String token, int bookingId) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl + 'confirm_finish';
    Map<String, String> body = {
      ConstantsManager.BOOKING_ID: bookingId.toString()
    };
    return _networkUtil.post(url, headers: _headers, body: body).then((res) {
      if (res[ConstantsManager.SERVER_ERROR] == null) {
        return {};
      } else {
        return res;
      }
    });
  }

  Future<Map<String, dynamic>> leaveCoworking(String token, int bookingId) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl + 'leave_coworking';
    Map<String, String> body = {
      ConstantsManager.BOOKING_ID: bookingId.toString()
    };
    return _networkUtil.post(url, headers: _headers, body: body).then((res) {
      if (res[ConstantsManager.SERVER_ERROR] == null) {
        return {};
      } else {
        return res;
      }
    });
  }

  Future<Map<String, dynamic>> extendFor30Minutes(String token, int bookingId) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl + 'extend_booking';
    Map<String, String> body = {
      ConstantsManager.BOOKING_ID: bookingId.toString(),
      "extend_time": "00:30"
    };
    return _networkUtil.post(url, headers: _headers, body: body).then((res) {
      if (res[ConstantsManager.SERVER_ERROR] == null) {
        return {};
      } else {
        return res;
      }
    });
  }


  Future<bool> cancelBooking(String token, int id) {
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl + 'cancel_booking';
    Map<String, String> body = {ConstantsManager.BOOKING_ID: id.toString()};
    return _networkUtil.post(url, headers: _headers, body: body).then((res) {
      if (res[ConstantsManager.SERVER_ERROR] == null)
        return true;
      else
        return false;
    });
  }

  Future<Map<String,dynamic>> getBooking (String token, int bookingId) {
    String url = _bookingUrl+ "get/$bookingId";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url, headers: _headers).then((response){
      if(response!=null && response[ConstantsManager.SERVER_ERROR] == null){
        return {"booking" : Booking.fromJson(response)};
      }else if(response !=null && response[ConstantsManager.SERVER_ERROR] !=null){
        return response;
      }
      else{
        return null;
      }
    });
  }
}
