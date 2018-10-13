import 'dart:async';

import 'package:intl/intl.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/network_util.dart';

class BookingApi{
  NetworkUtil _networkUtil = new NetworkUtil();
  Map<String, String> _headers = {'Accept': 'application/json'};
  static const _bookingUrl = ConstantsManager.BASE_URL+
      "bookings/";
  static BookingApi _instance = BookingApi.internal();
  BookingApi.internal();
  factory BookingApi() => _instance;

  Future<List<Booking>> getUserBookings(String token){
    String  url = ConstantsManager.BASE_URL+
        "users/get_my_bookings";
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url, headers: _headers).then((response){
      List<Booking> bookings = [];
      print("booking response $response");
      response.forEach((r){
        Booking b = Booking.fromJson(r);
        bookings.add(b);
      });
      return bookings;
    });

  }

  Future<List<Booking>> getPastBookings(String token, {DateTime date}){
    String  url = ConstantsManager.BASE_URL+
        "users/get_past_bookings";
    if (date != null){
      url += '?date=' + DateFormat.yMd().format(date);
    }
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    return _networkUtil.get(url, headers: _headers).then((response){
      List<Booking> bookings = [];
      response.forEach((b){
        bookings.add(Booking.fromJson(b));
      });
      return bookings;
    });
  }

  Future<Booking> book(String token, int coWorkingId, int numberOfSeats,
      String startHour, endHour, date){
    String startDate = date+"T"+startHour;
    String endDate = date+"T"+endHour;
    String url = ConstantsManager.BASE_URL+ "/bookings/create";

    _headers[ConstantsManager.TOKEN_HEADER] = token;
    Map<String,String>  body = {
      ConstantsManager.CO_WORKING_ID : coWorkingId.toString(),
      ConstantsManager.VISITORS_COUNT : numberOfSeats.toString(),
      ConstantsManager.BEGIN_DATE : startDate,
      ConstantsManager.END_DATE : endDate
    };


     return _networkUtil.post(url, headers: _headers, body: body)
        .then((serverResponse){
          return Booking.fromJson(serverResponse);
    });


  }

  Future<bool> cancelBooking(String token, int id){
    _headers[ConstantsManager.TOKEN_HEADER] = token;
    String url = _bookingUrl+'cancel_booking';
    print(' cancel booking url $url');
    print(' cancel booking id $id');
    print('header $_headers');
    Map<String, String> body = {ConstantsManager.BOOKING_ID : id.toString()};
    print('body $body');
    return _networkUtil.post(url, headers: _headers, body: body).then((res){
      if(res[ConstantsManager.SERVER_ERROR] ==null)
        return true;
      else return false;
    });

  }


}