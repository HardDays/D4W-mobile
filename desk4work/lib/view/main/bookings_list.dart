import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';

class BookingsListScreen extends StatefulWidget {
  final List<Booking> _bookings;
  final String _token;

  BookingsListScreen(this._bookings, this._token);

  @override
  State<StatefulWidget> createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsListScreen> {
  List<Booking> _bookings;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  StringResources _stringResources;
  CoWorkingApi _coWorkingApi;
  String _token;

  _BookingsListState(){
    _coWorkingApi = CoWorkingApi();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    _stringResources = StringResources.of(context);
    _bookings = widget._bookings; //TODO change it to the global model
    _token = widget._token;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
//            horizontal: _screenWidth * .0293,
            vertical: _screenHeight * .0225),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _bookings.length,
          itemBuilder: (ctx, index) {
            return Container(
                padding: EdgeInsets.only(top: _screenHeight * .015),
                child: _getBookingBuilder(_bookings[index])
            );
          },
        ),
      )
    );
  }

  Widget _getBookingCard(Booking booking) {

    return Card(
      margin: EdgeInsets.all(.0),
      child: Container(
        height: _screenHeight * .1409,
        width: _screenWidth * .9413,
        child: Container(
          height: _screenHeight * .1409,
          width: _screenWidth * .9413,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: booking.id,
                child: CachedNetworkImage(
                  imageUrl: ConstantsManager.IMAGE_BASE_URL+
                      "${booking.coWorking.imageId}",
                  width: _screenWidth * .2773,
                  height: _screenHeight * .1409,
                  errorWidget: Image.asset(
                    'assets/placeholder.png',
                    width: _screenWidth * .2773,
                    height: _screenHeight * .1409,
                  ),
                )
              ),
//
              Container(
                height: _screenHeight * .1409,
                padding: EdgeInsets.only(
                    left: _screenWidth * .0386,
                    top: _screenHeight * .0179),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      booking.coWorking?.shortName ?? " ",
                      style: Theme.of(context).textTheme.title,
                    ),
                    _buildDate(DateTime.parse(booking.createdAt)),
                    _getLowerCardPart(booking.endWork) ?? " ",
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLowerCardPart(String leavingTime) {
    int remaining;
    try{
      remaining = DateTime.now()
          .difference(DateTime.parse(leavingTime)).inHours;
    }catch(e){
      print("error parsing leaving time in booking list $e");
      remaining = 0;
    }
    String remainingTime;
    if(remaining.isNegative || remaining == 0) remainingTime = '00:00';
    else {
      int hours = (remaining ~/ 24);
      int minutes = (remaining %24);
      remainingTime  = '$hours:$minutes';
    }

    bool isTimeUp = (remainingTime.substring(0, 2) == '00' &&
        remainingTime.substring(3) == '00');
    Color textColor = isTimeUp ? Colors.orange : Colors.black;
    Color iconColor = isTimeUp
        ? Colors.orange : Theme.of(context).textTheme.caption.color;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: _screenHeight * .01799,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.access_time,
                color: iconColor,
              ),
              Container(
                height: _screenHeight * .01799,
                child: Text(
                  remainingTime,
                  style: Theme.of(context).textTheme.body1.copyWith(
                      color: textColor),
                  textAlign: TextAlign.end,

                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: isTimeUp ? _extendBooking(1) : _endBooking(1),
              child: Text(
                isTimeUp ? _stringResources.tExtend : _stringResources.tTerminate,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.orange),
              ),
            )
          ],
        )
      ],
    );
  }


  Future<CoWorking> _getCoWorking(int id){
    return _coWorkingApi.getCoWorking(_token, id);

  }

  FutureBuilder<CoWorking> _getBookingBuilder(Booking booking){
    return FutureBuilder<CoWorking>(
      future: _getCoWorking(booking.coworkingId),
      builder: (ctx, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none :
            return showMessage(_stringResources.mNoInternet);
          case ConnectionState.waiting :
            return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50.0),
                child: new CircularProgressIndicator()
            );
          case ConnectionState.done:
            if(snapshot.hasError){
              print("error  loading booking ${snapshot.error}");
              return showMessage(_stringResources.mServerError);
            }else{
              if(snapshot.data == null) return Container();
              else {
                booking.coWorking = snapshot.data;
                return Container(
                    child: _getBookingCard(booking)
                );
              }
            }
            break;
          case ConnectionState.active: break;
        }
      },
    );
  }

  _endBooking(int id) {}

  _extendBooking(int id) {}

  _openBooking(Booking booking) {}

  Text _buildDate(DateTime dateTime){
    String day  = dateTime.day.toString();
    String year = dateTime.year.toString();
    String month;
    switch(dateTime.month){
      case 1: month = _stringResources.tJanuary;
      break;
      case 2: month = _stringResources.tFebruary;
      break;
      case 3: month = _stringResources.tMarch;
      break;
      case 4: month = _stringResources.tApril;
      break;
      case 5: month = _stringResources.tMay;
      break;
      case 6: month = _stringResources.tJune;
      break;
      case 7: month = _stringResources.tJuly;
      break;
      case 8: month = _stringResources.tAugust;
      break;
      case 9: month = _stringResources.tSeptember;
      break;
      case 10: month = _stringResources.tOctober;
      break;
      case 11: month = _stringResources.tNovember;
      break;
      case 12: month = _stringResources.tDecember;
      break;

    }

    return Text("$day $month $year", style: Theme.of(context).textTheme.caption,);
  }

//  Widget _buildRemainingTime(String end){
//    Duration remaining = DateTime.parse(end).difference(DateTime.now());
//    String remainingTime;
//    Color textColor;
//    Color iconColor;
//    bool isTimeOver = remaining.isNegative;
//    if(!isTimeOver){
//      int  hours = (remaining.inMinutes ~/60);
//      int minutes = remaining.inMinutes % 60;
//      remainingTime = '$hours:$minutes';
//      textColor = Colors.black;
//      iconColor = Theme.of(context).textTheme.caption.color;
//    }else{
//      remainingTime = "00:00";
//      textColor =  Colors.orange;
//      iconColor =  Colors.orange;
//
//    }
//    return Row(
//      children: <Widget>[
//        Icon(Icons.access_time, color: iconColor,),
//        Text(
//          remainingTime,
//          style: Theme.of(context).textTheme.subhead.copyWith(color: textColor))
//      ],
//    );
//
//  }

  Widget showMessage(String message){
    return Center(child: Text(message),);
  }
}
