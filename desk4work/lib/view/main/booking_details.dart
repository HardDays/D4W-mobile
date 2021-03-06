import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/dots_indicator.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/dialogs.dart';
import 'package:desk4work/view/main/payment_method.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:desk4work/view/main/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetails extends StatefulWidget {
  final Booking _booking;

  BookingDetails(this._booking);

  @override
  State<StatefulWidget> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  double _screenHeight, _screenWidth, _progress;
  bool _isTimeUp, _hasFreeMinutes, _isLoading;
  String _remainingTime;
  StringResources _stringResources;
  BookingApi _bookingApi;
  Booking _booking;
  final _controller = new PageController();
  Timer _countDownTimer;

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;
  GlobalKey<ScaffoldState> _screenState = GlobalKey();
  static const platform = const MethodChannel('desk4Work/payment');


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;

    _stringResources = StringResources.of(context);

    return Scaffold(
      key: _screenState,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Text(
              _booking.coWorking.shortName,
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadBooking,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    _buildHeader(_booking.coWorking.images),
                    _buildProgressBar(),
                    _buildStartEndWidget(),
                    Padding(
                        padding: EdgeInsets.only(top: _screenHeight * .0465)),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _screenWidth * .0627),
                      height: _screenHeight * .1454,
                      child: _buildChronoWidget(),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: _screenHeight * .057)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildExtendButton(),
                        _buildTerminateButton()
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    _booking = widget._booking;
    _isTimeUp = false;
    _isLoading = false;
    _progress = _getProgress();
    _remainingTime = _getRemainingTime();
    _hasFreeMinutes = false;
    _bookingApi = BookingApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then((sp) {
        int id = sp.getInt(_booking.id.toString());
        print('booking_id $id');
        if (id != null && id == _booking.id) {
          setState(() {
            _isLoading = false;
          });
          _startCountDown();
        } else {
          setState(() {
            _isLoading = true;
          });
          _loadBooking().then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      });
    });
    super.initState();
  }

  Widget _buildHeader(List<int> imageIds) {
    return Container(
      height: _screenHeight * .3283,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: CircularProgressIndicator(),
                height: (_screenHeight * .3238),
                errorWidget: Icon(
                  Icons.error,
                  size: (_screenHeight * .3238),
                ),
                imageUrl: ConstantsManager.BASE_URL +
                    "images/get_full/${imageIds[index]}",
              );
            },
            itemCount: imageIds?.length ?? 0,
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new Container(
              color: Colors.grey[800].withOpacity(0.5),
              padding: const EdgeInsets.all(8.0),
              child: new Center(
                child: new DotsIndicator(
                  controller: _controller,
                  itemCount: imageIds?.length ?? 0,
                  onPageSelected: (int page) {
                    _controller.animateToPage(
                      page,
                      duration: _kDuration,
                      curve: _kCurve,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: _screenHeight * .0045,
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey,
        value: _progress,
      ),
    );
  }

  Widget _buildStartEndWidget() {
    String start;
    String end;

    try {
      Duration offset = DateTime.now().timeZoneOffset;
      DateTime startTime = DateTime.parse(_booking.beginDate);
      startTime = startTime.add(offset);
      DateTime endTime = DateTime.parse(_booking.endDate);
      endTime = endTime.add(offset);
      int startHours = startTime.hour;
      int startMinutes = startTime.minute;

      String startHoursAsString =
          (startHours < 10) ? '0$startHours' : startHours.toString();
      String startMinutesAsString =
          (startMinutes < 10) ? '0$startMinutes' : startMinutes.toString();

      start = '$startHoursAsString:$startMinutesAsString';

      int endHours = endTime.hour;
      int endMinutes = endTime.minute;

      String endHoursAsString =
          (endHours < 10) ? '0$endHours' : endHours.toString();
      String endMinutesAsString =
          (endMinutes < 10) ? '0$endMinutes' : endMinutes.toString();

      end = '$endHoursAsString:$endMinutesAsString';
    } catch (e) {
      print('parsing error $e');
      start = "--:--";
      end = "--:--";
    }

    return Container(
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: Colors.black26, width: .5))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    start,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    _stringResources.hStart +
                        ' ' +
                        _buildDate(DateTime.parse(_booking.beginDate)).data,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
            Container(
              width: .5,
              height: _screenHeight * .1094,
              decoration: BoxDecoration(color: Colors.black26),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    end,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    _hasFreeMinutes
                        ? _stringResources.tFreeMinutes
                        : _stringResources.hEnd +
                            ' ' +
                            _buildDate(DateTime.parse(_booking.endDate)).data,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChronoWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            _remainingTime,
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: Colors.black),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: _screenWidth * .1589),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _stringResources.tHours,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  _stringResources.tMinutes,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  _stringResources.tSeconds,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _loadBooking() {
    return SharedPreferences.getInstance().then((sp) {
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      _bookingApi.getBooking(token, _booking.id).then((bookingMaybe) {
        print('booking: $_booking');
        if (bookingMaybe[ConstantsManager.SERVER_ERROR] == null) {
          Booking booking = bookingMaybe["booking"];
          if (booking != null) {
            setState(() {
              _booking = booking;
              _isLoading = false;
            });
            _startCountDown();

            if (!_booking.isUserLeaving && _booking.isVisitConfirmed)
              _showConfirmVisitDialog();
            if(booking.isClosed !=null && booking.isClosed)
              _showAdminTerminateDialog();
          }
        } else {
          _showToast(_stringResources.eServer);
        }
        return Future.value(null);
      }).catchError((error) {
        print('server error: $error');
        _showToast(_stringResources.eServer);
        return Future.value(null);
      });
    });
  }

  Widget _buildTerminateButton() {
    String buttonText = _stringResources.tTerminate;

    Gradient oragandeGradient =
        BoxDecorationUtil.getDarkOrangeGradient().gradient;

    return InkWell(
      child: Container(
        width: _screenWidth * .872 / 2,
        height: _screenHeight * .0825,
        decoration: BoxDecoration(
            gradient: oragandeGradient,
            borderRadius: BorderRadius.all(Radius.circular(48.0))),
        child: Center(
          child: Text(
            buttonText,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          ),
        ),
      ),
      onTap: _booking.isUserLeaving
          ? () {
              _showToast(_stringResources.mStopRequestPending);
            }
          : () => _onTerminateRequest(),
    );
  }

  _onTerminateRequest() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _stringResources.aEndSession,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      child: Text(_stringResources.tNo.toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                      child: Text(_stringResources.tYes.toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                        _terminateBooking();
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildExtendButton() {
    String buttonText = _stringResources.tExtend;

    Gradient oragandeGradient =
        BoxDecorationUtil.getDarkOrangeGradient().gradient;

    return InkWell(
        child: Container(
          width: _screenWidth * .872 / 2,
          height: _screenHeight * .0825,
          decoration: BoxDecoration(
              gradient: oragandeGradient,
              borderRadius: BorderRadius.all(Radius.circular(48.0))),
          child: Center(
            child: Text(
              buttonText,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        onTap: () => _extendBooking());
  }

  _showConfirmVisitDialog() {
    SharedPreferences.getInstance().then((sp) {
      int id = sp.getInt(_booking.id.toString());
      if (id != null && id == _booking.id) {
        setState(() {
          _isLoading = false;
        });
        _startCountDown();
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _stringResources.tPromptConfirmVisit +
                        '${_booking.coWorking?.shortName ?? " "}?',
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                          child: Text(_stringResources.tNo.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      FlatButton(
                          child: Text(_stringResources.tYes.toUpperCase()),
                          onPressed: () {
                            _confirmVisit();
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              ),
            );
          },
        );
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (ctx) {
//              return CupertinoAlertDialog(
//                  title: Text(_stringResources.tPromptConfirmVisit +
//                      '${_booking.coWorking?.shortName ?? " "}?'),
//                  actions: [_buildNoActionButton(), _buildYesActionButton()]);
//            });
      }
    });
  }

  Widget _buildNoActionButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(_stringResources.tNo),
      highlightColor: Colors.orange,
      color: Colors.white,
      textColor: Colors.grey,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(21.0)),
    );
  }

  Widget _buildYesActionButton() {
    return RaisedButton(
      onPressed: _confirmVisit,
      highlightColor: Colors.orange,
      color: Colors.white,
      textColor: Colors.grey,
      child: Text(_stringResources.tYes),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(21.0)),
    );
  }

  _terminateBooking() {
    if (!_booking.isUserLeaving) {
      _launchPayment().then((_){
        setState(() {
          _isLoading = true;
        });
        SharedPreferences.getInstance().then((sp) {
          String token = sp.getString(ConstantsManager.TOKEN_KEY);
          _bookingApi.leaveCoworking(token, _booking.id).then((isCanceled) {
            if (isCanceled != null && isCanceled.length == 0) {
              _loadBooking().then((_) {
                sp.remove(_booking.id.toString());
//              _showToast(_stringResources.mStopRequestSent);
                Navigator.of(context).pop(widget._booking);
              });
            } else {
              print('can\'t cancel the booking $isCanceled');
              _showToast(_stringResources.eServer);
            }
          });
        });
      });
    } else {
      _showToast(_stringResources.mStopRequestPending);
    }
  }

  Future<bool> _launchPayment()async{
    double price = _booking.price;
    String coWorking = _booking.coWorking.shortName;
    try{
     return SharedPreferences.getInstance().then((sp){
        int paymentMethod = sp.getInt(PaymentMethod.PAYMENT_OPTION_KEY);
        if(paymentMethod == PaymentMethod.CARD_OPTION){
          platform.invokeMethod('startPaymentProcess', {Payment.AMOUNT_EXTRA : price, Payment.CO_WORKING_NAME : coWorking}).then((_){
            return Future.value(true);
            }).catchError((error){
            print('payment error: $error');
            return Future.value(false);
          });
        }else{
          Dialogs.showMessage(context, '', _stringResources.tCashPaymentPromt, _stringResources.tOk).then((_){
            return Future.value(true);
          });
        }
      });
       

    }on PlatformException catch(e){
      print("error processing to payment: $e");
      Dialogs.showMessage(context, ' ', _stringResources.eProcessingPayment, _stringResources.tOk);
      return Future.value(false);
    }catch(e){
      print("error processing to payment: $e");
      Dialogs.showMessage(context, ' ', _stringResources.eProcessingPayment, _stringResources.tOk);
      return Future.value(false);
    }
  }

  _extendBooking() {
    if (_booking.isExtendPending) {
      _showToast(_stringResources.mExtendPending);
    } else {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences.getInstance().then((sp) {
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        _bookingApi.extendFor30Minutes(token, _booking.id).then((resp) {
          if (resp != null) {
            if (resp.length == 0) {
              _showToast(_stringResources.mExtendRequestSent);
              _loadBooking().then((_) {
                setState(() {
                  _isLoading = false;
                });
              });
            }
          } else
            _showToast(_stringResources.eServer);
        });
      });
    }
  }

  _getUpdate() {
    _loadBooking();
  }

  _showAdminTerminateDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx){
        return AlertDialog(
          content: Text(_stringResources.mBookingSessionEnded),
          actions: <Widget>[
            FlatButton(onPressed: ()=>_showRefreshedList(), child: Text(_stringResources.tOk.toUpperCase()))
          ],
        );
      }
    );
  }

  _showRefreshedList(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => MainScreen(
          firstTab: 1,
        ))
    );
  }
  _confirmVisit() {
//    SharedPreferences.getInstance().then((sp) {
//      String token = sp.getString(ConstantsManager.TOKEN_KEY);
//      _bookingApi.confirmVisit(token, _booking.id).then((serverResp){
//        if(serverResp!=null && serverResp[ConstantsManager.SERVER_ERROR] == null){
//          sp.setInt(_booking.id.toString(), _booking.id);
//          setState(() {
//            _hasBeenThere = true;
//          });
//        }
//      }).catchError((error){
//
//      });
//
//    });

    SharedPreferences.getInstance().then((sp) {
      sp.setInt(_booking.id.toString(), _booking.id);
      _startCountDown();
    });

//    Navigator.pop(context);
    setState(() {
      _isLoading = false;
    });
  }

  double _getProgress() {
    String start = _booking.beginDate;
    String end = _booking.endDate;
    DateTime now = _toLocalDateTime(DateTime.now().toUtc());
    if (start != null && end != null) {
      try {
        DateTime startTime = _toLocalDateTime(DateTime.parse(start.substring(0, start.length - 1)));
        DateTime endTime = _toLocalDateTime(DateTime.parse(end.substring(0, start.length - 1)));
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          int totalTime = endTime.difference(startTime).inSeconds;
          int consumedTime = now.difference(startTime).inSeconds;
          double progress = ((consumedTime * 100) / totalTime).toDouble();
          return progress;
        } else if (now.isBefore(startTime)) {
          return .0;
        } else
          return 1.0;
      } catch (e) {
        print('date parsing error: $e');
      }
    }
    return .0;
  }

  DateTime _toLocalDateTime(DateTime toConvert){
    Duration offset = DateTime.now().timeZoneOffset;
    return toConvert.add(offset);
  }

  String _getRemainingTime() {
    Duration remaining;
    String start = _booking.beginDate;
    String end = _booking.endDate;
    DateTime now = DateTime.now();
    Duration offset = now.timeZoneOffset;
    try {
//      DateTime startTime = DateTime.parse(start.substring(0, start.length - 1));
      DateTime startTime = DateTime.parse(start);
      startTime = startTime.add(offset);
      DateTime endTime = DateTime.parse(end);
      endTime = endTime.add(offset);
//      DateTime endTime = DateTime.parse(end.substring(0, end.length - 1));
      print('start :$startTime, end:$endTime');

      now.toUtc();
      DateTime localNow = now.toUtc();
      localNow = localNow.add(offset);

      if (localNow.isBefore(startTime)) {
          remaining = endTime.difference(startTime);
          print('remaining time from condition 1: $remaining');
        }
      else if (localNow.isAfter(startTime) && localNow.isBefore(endTime)) {
          remaining = endTime.difference(localNow);
          print('remaining time from condition 2: $remaining');
        }
      else {
          remaining = Duration();
          print('remaining time from condition 3: $remaining');
        }
    } catch (e) {
      print("error parsing leaving time in booking list $e");
      remaining = Duration();
    }

    String remainingTime;
    if (remaining.isNegative || remaining.inMinutes == 0) {
      print('negative');
      setState(() {
        _isTimeUp = true;
      });
      remainingTime = '00 : 00 : 00';
    } else {
      int hours = (remaining.inMinutes ~/ 60);
      int minutes = (remaining.inMinutes % 60);
      int seconds = (remaining.inSeconds % 60);

      String hoursAsString = (hours < 10) ? '0$hours' : hours.toString();
      String minutesAsString =
          (minutes < 10) ? '0$minutes' : minutes.toString();
      String secAsString = (seconds < 10) ? '0$seconds' : seconds.toString();

      remainingTime = '$hoursAsString : $minutesAsString : $secAsString';
    }

    return remainingTime;
  }

  _startCountDown() {
    if(_countDownTimer ==null || !_countDownTimer.isActive){

      try {
        const oneSec = const Duration(seconds: 1);
        _countDownTimer = Timer.periodic(oneSec, (Timer t) {
          if (_isTimeUp) {
            t.cancel();
          } else {
            setState(() {
              _progress = _getProgress();
              _remainingTime = _getRemainingTime();
            });
            print(' remaining time :$_remainingTime');
          }
        });
      } catch (e) {
        print('contDown error $e');
      }
    }
  }


  @override
  void dispose() {
    _countDownTimer?.cancel();
    super.dispose();
  }



  _showToast(String message) {
    setState(() {
      _isLoading = false;
    });
    _screenState.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Text _buildDate(DateTime dateTime) {
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();
    int hour = dateTime.hour;
    int min = dateTime.minute;
    String hourString = hour > 9 ? hour.toString() : '0$hour';
    String minString = min > 9 ? min.toString() : '0$min';
//    String time = '$hourString'+ 'h$minString';
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
      " $day $month $year",
      style: Theme.of(context).textTheme.caption,
    );
  }
}
