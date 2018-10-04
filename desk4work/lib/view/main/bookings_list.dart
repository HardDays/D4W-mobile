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
            horizontal: _screenWidth * .293, vertical: _screenHeight * .0225),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _bookings.length,
          itemBuilder: (ctx, index) {
            _getBookingBuilder(_bookings[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newBooking,
        child: Container(
          decoration: BoxDecorationUtil.getOrangeGradient(),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getBookingCard(Booking booking) {
    return Card(
      margin: EdgeInsets.all(.0),
      child: Container(
        height: _screenHeight * .1409,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: booking.id,
              child: CachedNetworkImage(
                imageUrl: ConstantsManager.IMAGE_BASE_URL+
                    "${booking.coworkingImageId}",
                width: _screenWidth * .2773,
                errorWidget: Image.asset(
                  'assets/placeholder.png',
                  width: _screenWidth * .2773,
                ),
              )
            ),
//
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _screenWidth * .0386,
                  vertical: _screenHeight * .0179),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    booking.coWorking?.shortName ?? " ",
                  ),
                  Text(
                    booking.beginWork ?? " ",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  _getLowerCardPart(booking.endWork) ?? " ",
                ],
              ),
            )
          ],
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
        remainingTime.substring(2) == '00');
    Color color = isTimeUp ? Colors.red : Colors.black;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: color,
            ),
            Text(
              remainingTime,
              style: Theme.of(context).textTheme.body1.copyWith(color: color),
            )
          ],
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
                return _getBookingCard(booking);
              }
            }
            break;
          case ConnectionState.active: break;
        }
      },
    );
  }


  _newBooking() {}

  _endBooking(int id) {}

  _extendBooking(int id) {}

  _openBooking(Booking booking) {}

  Widget showMessage(String message){
    return Center(child: Text(message),);
  }
}
