import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/main/booking_details.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingsListScreen extends StatefulWidget {
  List<Booking> _bookings;
  final String _token;

  BookingsListScreen(List<Booking> bookings, this._token){
    _bookings = (bookings ?? []).where((b){
      return DateTime.now().isBefore(DateTime.parse(b.endDate)) && !b.isClosed && !b.isUserLeaving && !b.isUserCanceling;
    }).toList();
  }

  removeBooking(int id){
    Booking booking;
    _bookings.forEach((b){
      if(b.id == id){
        booking = b;
      }
    });
    if(booking!=null) _bookings.remove(booking);
  }

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
  BookingApi _bookingApi;
  GlobalKey<ScaffoldState> _screenState = GlobalKey<ScaffoldState>();
  bool _isLoading;
  int _loadingCount;

  @override
  void initState() {
    _bookingApi = BookingApi();
    _token = widget._token;
    _coWorkingApi = CoWorkingApi();
    _bookings = widget._bookings;
    _isLoading = false;
    _loadingCount = _bookings.length;
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        _isLoading = true;
      });
      if(_bookings == null || _bookings.length <1){

        _refresh().then((_){
          setState(() {
            _isLoading = false;
          });
        });
      }else{
        for(Booking b in _bookings){
          DateTime endDateTime = DateTime.parse(b.endDate);
          print('booking list: $b');
          if(endDateTime.isAfter(DateTime.now())){
          int coworkingId = b.coworkingId;
          _getCoWorking(coworkingId).then((coworking){
            b.coWorking = coworking;
          }).catchError((error){
            print('load coworking error $error');
            _showToast(_stringResources.eServer);
          });
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    _stringResources = StringResources.of(context);
    return Scaffold(
        key: _screenState,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(_stringResources.tBookings,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.white)),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.symmetric(
//            horizontal: _screenWidth * .0293,
                    vertical: _screenHeight * .0225),
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _bookings.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: _screenHeight * .015,
                              horizontal: _screenWidth * .0293),
                          child: _getBookingBuilder(index));
                    },
                  ),
                ),
              ));
  }

  Widget _getBookingCard(Booking booking) {
    return InkWell(
      onTap: () => _openBooking(booking),
      child: Card(
        margin: EdgeInsets.all(.0),
        elevation: 2.0,
        child: Container(
          height: _screenHeight * .1409,
//        width: _screenWidth * .9413,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                  tag: booking.id,
                  child: CachedNetworkImage(
                    imageUrl: ConstantsManager.IMAGE_BASE_URL +
                        "${booking.coWorking.imageId}",
                    fit: BoxFit.fill,
                    width: _screenWidth * .2773,
                    height: _screenHeight * .1409,
                    errorWidget: Image.asset(
                      'assets/placeholder.png',
                      width: _screenWidth * .2773,
                      height: _screenHeight * .1409,
                      fit: BoxFit.fill,
                    ),
                  )),
//
              Container(
                height: _screenHeight * .1409,
                width: _screenWidth * .6613,
                padding: EdgeInsets.only(
                    left: _screenWidth * .0386, top: _screenHeight * .01),
                child: Stack(
                  children: <Widget>[
                    Text(
                      booking.coWorking?.shortName ?? " ",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Positioned(
                        top: _screenHeight * .050,
                        child: _buildDate(DateTime.parse(booking.beginDate))),
                    Positioned(
                      child: _buildRemainingTime(
                          booking.beginDate, booking.endDate),
                      top: _screenHeight * .0809,
                    ),
                    Positioned(
                        top: _screenHeight * .0915,
                        left: _screenWidth * .4173,
                        child: _buildTerminateOrExtendTextButton(booking))

//                    _getLowerCardPart(booking.endWork) ?? " ",
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildTerminateOrExtendTextButton(Booking booking) {
    bool isBookingTimeUp = _isBookingTimeUp(booking);

    return InkWell(
      onTap: (!booking.isUserLeaving || !booking.isExtendPending) ? (isBookingTimeUp
          ? () => _extendBooking(booking)
          : () => _endBooking(booking.id)):(){},
      child: Text(
        (!booking.isUserLeaving && !booking.isExtendPending) ? (isBookingTimeUp
            ? _stringResources.tExtend
            : _stringResources.tTerminate) : ' ',
        style:
            Theme.of(context).textTheme.button.copyWith(color: Colors.orange),
      ),
    );
  }



  Future<CoWorking> _getCoWorking(int id) {
    return _coWorkingApi.getCoWorking(_token, id);
  }

//  FutureBuilder<CoWorking> _getBookingBuilder(index) {
  Widget _getBookingBuilder(index) {
    Booking booking = _bookings[index];
    return Container(child: _getBookingCard(booking));
//    return FutureBuilder<CoWorking>(
//      future: _getCoWorking(booking.coworkingId),
//      builder: (ctx, snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.none:
//            return showMessage(_stringResources.mNoInternet);
//          case ConnectionState.waiting:
//            return Container(
//              alignment: Alignment.center,
//              margin: const EdgeInsets.only(top: 8.0),
//              width: _screenWidth * .2773,
//              height: _screenHeight * .1409,
//              child: Card(
//                margin: EdgeInsets.all(.0),
//                elevation: 2.0,
//                child: Container(
//                  height: _screenHeight * .1409,
////        width: _screenWidth * .9413,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Hero(
//                          tag: -booking.id,
//                          child: CachedNetworkImage(
//                            imageUrl: ConstantsManager.IMAGE_BASE_URL +
//                                "${booking.coWorking.imageId}",
//                            fit: BoxFit.fill,
//                            width: _screenWidth * .2773,
//                            height: _screenHeight * .1409,
//                            errorWidget: Image.asset(
//                              'assets/placeholder.png',
//                              width: _screenWidth * .2773,
//                              height: _screenHeight * .1409,
//                              fit: BoxFit.fill,
//                            ),
//                          )),
////
//                      Container(
//                        height: _screenHeight * .1409,
//                        width: _screenWidth * .6613,
//                        padding: EdgeInsets.only(
//                            left: _screenWidth * .0386,
//                            top: _screenHeight * .01),
//                        child: Stack(
//                          children: <Widget>[
//                            Text(
//                              booking.coWorking?.shortName ?? " ",
//                              style: Theme.of(context).textTheme.body2,
//                            ),
//                            Positioned(
//                                top: _screenHeight * .050,
//                                child: _buildDate(
//                                    DateTime.parse(booking.beginDate))),
//                            Positioned(
//                              child: _buildRemainingTime(
//                                  booking.beginDate, booking.endDate),
//                              top: _screenHeight * .0809,
//                            ),
//                            Positioned(
//                                top: _screenHeight * .0915,
//                                left: _screenWidth * .4173,
//                                child:
//                                    _buildTerminateOrExtendTextButton(booking))
//
////                    _getLowerCardPart(booking.endWork) ?? " ",
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            );
//          case ConnectionState.done:
//            if (snapshot.hasError) {
//              return showMessage(_stringResources.mServerError);
//            } else {
//              if (snapshot.data == null)
//                return Container(
//                  width: _screenWidth * .2773,
//                  height: _screenHeight * .1409,
//                );
//              else {
//                booking.coWorking = snapshot.data;
//                return Container(child: _getBookingCard(booking));
//              }
//            }
//            break;
//          case ConnectionState.active:
//            break;
//        }
//      },
//    );
  }

  _endBooking(int id) {
    setState(() {
      _isLoading = true;
    });
    _bookingApi.leaveCoworking(_token, id).then((isCanceled) {
      if (isCanceled != null && isCanceled.length == 0) {
        _showToast(_stringResources.mStopRequestSent);
        SharedPreferences.getInstance().then((sp){
          sp.remove(id.toString());
        });
        int toBeRemovedSoon;
        _bookings.forEach((b) {
          if (b.id == id) {
            toBeRemovedSoon = _bookings.indexOf(b);
          }
        });
        if (toBeRemovedSoon != null) {
          _bookings[toBeRemovedSoon].isUserLeaving = true;
//          _bookings.remove(toBeRomovedSoon);
          setState(() {
            _bookings = _bookings;
          });
        }
      } else {
        print('can\'t cancel the booking $isCanceled');
        _showToast(_stringResources.eServer);
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  _extendBooking(Booking booking) {
    if (booking.isExtendPending) {
      _showToast(_stringResources.mExtendPending);
    } else {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences.getInstance().then((sp) {
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        _bookingApi.extendFor30Minutes(token, booking.id).then((resp) {
          if (resp != null) {
            if (resp.length == 0) {
              _showToast(_stringResources.mExtendRequestSent);
              int toBeExtended;
              int id = booking.id;
              _bookings.forEach((b) {
                if (b.id == id) {
                  toBeExtended = _bookings.indexOf(b);
                }
              });
              if (toBeExtended != null) {
//          _bookings.remove(toBeRomovedSoon);
                _bookings[toBeExtended].isExtendPending = true;
                setState(() {
                  _bookings = _bookings;
                });
              }
              setState(() {
                _isLoading = false;
              });
            }
          } else
            _showToast(_stringResources.eServer);
        });
      });
    }
  }

  Future<Null> _refresh(){
     return SharedPreferences.getInstance().then((sp){
       String token = sp.getString(ConstantsManager.TOKEN_KEY);
        _bookingApi.getUserBookings(token).then((bookings){
         if(bookings!=null && bookings.length>0){
           List<Booking> temp = [];
           for(Booking b in bookings){
             DateTime endDateTime = DateTime.parse(b.endDate);
             if(endDateTime.isAfter(DateTime.now()) && !b.isClosed && !b.isUserLeaving && !b.isUserCanceling){
               temp.add(b);
               int coworkingId = b.coworkingId;
               _getCoWorking(coworkingId).then((coworking){
                 b.coWorking = coworking;
               }).catchError((error){
                 print('load coworking error $error');
                 _showToast(_stringResources.eServer);
               });
             }

           }
           setState(() {
             _bookings = temp;
           });
         }
         return Future.value(null);
       }).catchError((error){
         showMessage(_stringResources.mServerError);
         return Future.value(null);
       });
     });
  }

  _openBooking(Booking booking) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => BookingDetails(booking)))
        .then((b) {
      if (b != null && (b.id == booking.id)) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>MainScreen(firstTab: 1,)));
      }
    });
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

  Widget _buildRemainingTime(String start, String end) {
    Duration remaining;

    try {
      DateTime startTime = DateTime.parse(start);
      DateTime endTime = DateTime.parse(end);
      DateTime now = DateTime.now();
      if (now.isBefore(startTime))
        remaining = DateTime.parse(end).difference(DateTime.parse(start));
      else if (now.isAfter(startTime) && now.isBefore(endTime))
        remaining = DateTime.parse(end).difference(now);
      else
        remaining = Duration();
    } catch (e) {
      print('remaining time parsing error: $e');
      remaining = Duration(minutes: 0, hours: 0);
    }
    String remainingTime;
    Color textColor;
    Color iconColor;
    bool isTimeOver = remaining.isNegative;
    if (!isTimeOver) {
      int hours = (remaining.inMinutes ~/ 60);
      int minutes = remaining.inMinutes % 60;
      String hoursAsString = hours.toString();
      String minutesAsString = minutes.toString();
      if (hours < 10) hoursAsString = '0$hoursAsString';
      if (minutes < 10) minutesAsString = '0$minutesAsString';

      remainingTime = '$hoursAsString:$minutesAsString';
      textColor = Colors.black;
      iconColor = Theme.of(context).textTheme.caption.color;
    } else {
      remainingTime = "00:00";
      textColor = Colors.orange;
      iconColor = Colors.orange;
    }
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: iconColor,
        ),
        Text(remainingTime,
            style: Theme.of(context).textTheme.body1.copyWith(color: textColor))
      ],
    );
  }

  bool _isBookingTimeUp(Booking b) {
    try {
      DateTime beginDate = DateTime.parse(b.beginDate);
      if (beginDate.isAfter(DateTime.now())) return false;
      DateTime endWork = DateTime.parse(b.endDate);
      return endWork.difference(DateTime.now()).isNegative;
    } catch (e) {
      print('dateparsing error: $e');
      return true;
    }
  }

  Widget showMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  _showToast(String message) {
    setState(() {
      _isLoading = false;
    });
    _screenState.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
