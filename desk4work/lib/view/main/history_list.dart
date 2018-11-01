import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryListScreen extends StatefulWidget {
  HistoryListScreen();

  @override
  State<StatefulWidget> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryListScreen> {
  List<Booking> _bookings;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  StringResources _stringResources;
  BookingApi _bookingnsApi;
  String _token;

  _HistoryListState(){
    _bookingnsApi = BookingApi();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    _stringResources = StringResources.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text(
          _stringResources.tHistory,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[]
      ),
      backgroundColor: Color(0xFFE5E5E5),
      body: _buildCoWorkingList()
    );
  }
FutureBuilder<List<Booking>> _buildCoWorkingList(){
    return FutureBuilder<List<Booking>>(
      future: _getBookings(),
      builder: (ctx, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none :
            return _showMessage(_stringResources.mNoInternet);
          case ConnectionState.waiting :
            return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50.0),
                child: new CircularProgressIndicator()
            );
          case ConnectionState.done:
            if(snapshot.hasError){
              print("error  loading coWorkings ${snapshot.error}");
              return _showMessage(_stringResources.mServerError);
            }else{
              if  (snapshot.data == null  || snapshot.data.isEmpty){
                return _showMessage(_stringResources.tNoBookings);
              }
              else {
                _bookings = snapshot.data;
                return Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _bookings.length,
                    itemBuilder: (ctx, index){
                      return _getBookingCard(_bookings[index]);
                    }
                  )
                );
              }
            }
            break;
          case ConnectionState.active: break;
        }
      },
    );
  }

  Future<List<Booking>> _getBookings(){
    return SharedPreferences.getInstance().then((sp){
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      return _bookingnsApi.getPastBookings(token).then((bookings){
        return bookings;
      });
    });
  }

  Widget _getBookingCard(Booking booking){
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0))
      ),
      width: _screenWidth * 1.0,
      height: _screenHeight * 0.15,
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: _screenHeight * 0.15,
              height: _screenHeight * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                child: booking.coWorking.imageId != null ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: Image.asset('assets/placeholder.png',
                   width: _screenHeight * 0.15,
                   height: _screenHeight * 0.15,                        
                 ),
                  errorWidget: Image.asset('assets/placeholder.png',
                    width: _screenHeight * 0.15,
                    height: _screenHeight * 0.15,                        
                  ),
                  imageUrl: ConstantsManager.IMAGE_BASE_URL + "${booking.coWorking.imageId}"                 
                ) : Image.asset('assets/placeholder.png',
                  width: _screenHeight * 0.15,
                  height: _screenHeight * 0.15,                        
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: _screenWidth * 0.6,
                    child: Text(booking.coWorking.shortName ?? booking.coWorking.fullName,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0
                      ),
                    ),
                  ),
                  //will be remaked after refactor
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: _screenWidth * 0.6,
                    child: _buildDate(DateTime.parse(booking.beginDate)),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Text _buildDate(DateTime dateTime) {
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();
    int hour = dateTime.hour;
    int min = dateTime.minute;
    String hourString = hour > 9 ? hour.toString() : '0$hour';
    String minString = min > 9 ? min.toString() : '0$min';
    String time = '$hourString' + ':$minString';
    String month;
    switch (dateTime.month) {
      case 1:
        month = _stringResources.tJanuary;
        break;
      case 2:
        month = _stringResources.tFebruary;
        break;
      case 3:
        month = _stringResources.tMarch;
        break;
      case 4:
        month = _stringResources.tApril;
        break;
      case 5:
        month = _stringResources.tMay;
        break;
      case 6:
        month = _stringResources.tJune;
        break;
      case 7:
        month = _stringResources.tJuly;
        break;
      case 8:
        month = _stringResources.tAugust;
        break;
      case 9:
        month = _stringResources.tSeptember;
        break;
      case 10:
        month = _stringResources.tOctober;
        break;
      case 11:
        month = _stringResources.tNovember;
        break;
      case 12:
        month = _stringResources.tDecember;
        break;
    }

    return Text(
      "$day $month $year $time",
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _showMessage(String message){
    return Center(
      child: Text(message,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300
        )
      ),
    );
  }
}
