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
      response['bookgins'].forEach((Booking b){
        bookings.add(b);
      });
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
      print("booking response $response");
      response.forEach((b){
        bookings.add(Booking.fromJson(b));
      });
      return bookings;
    });
  }
}