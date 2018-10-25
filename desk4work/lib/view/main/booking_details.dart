import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/dots_indicator.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetails extends StatefulWidget {
  final Booking _booking;

  BookingDetails(this._booking);

  @override
  State<StatefulWidget> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  double _screenHeight, _screenWidth, _progress;
  bool _isTimeUp, _hasFreeMinutes;
  String _remainingTime;
  StringResources _stringResources;
  BookingApi _bookingApi;
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;

    _stringResources = StringResources.of(context);


    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Text(
              widget._booking.coWorking.shortName,
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: Column(
        children: <Widget>[
          _buildHeader(widget._booking.coWorking.images),
          _buildProgressBar(),
          _buildStartEndWidget(),
          Padding(padding: EdgeInsets.only(top: _screenHeight * .0465)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: _screenWidth * .0627),
            height: _screenHeight * .1454,
            child: _buildChronoWidget(),
          ),
          Padding(padding: EdgeInsets.only(top: _screenHeight * .057)),
          _buildTerminatedExtendButton()
        ],
      ),
    );
  }

  @override
  void initState() {
    _isTimeUp = false;
    _progress = _getProgress();
    _remainingTime = _getRemainingTime();
    _hasFreeMinutes = false;
    _bookingApi = BookingApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountDown();
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
                imageUrl:  ConstantsManager.BASE_URL
                    +"images/get_full/${imageIds[index]}",
              );
            },
            itemCount:imageIds?.length ?? 0,
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
      DateTime startTime = DateTime.parse(widget._booking.beginDate);
      DateTime endTime = DateTime.parse(widget._booking.endDate);
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
                    _stringResources.hStart,
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
                        : _stringResources.hEnd,
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

  Widget _buildTerminatedExtendButton() {
    String buttonText =
        (_isTimeUp) ? _stringResources.tExtend : _stringResources.tTerminate;

    Gradient oragandeGradient =
        BoxDecorationUtil.getDarkOrangeGradient().gradient;

    return Center(
      child: InkWell(
        child: Container(
          width: _screenWidth * .872,
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
        onTap: (_isTimeUp) ?()=> _extendBooking() :()=> _terminateBooking(),
      ),
    );
  }

  _terminateBooking() {
    SharedPreferences.getInstance().then((sp){
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      _bookingApi.cancelBooking(token, widget._booking.id).then((isCanceled){
        if(isCanceled)
          Navigator.of(context).pop(widget._booking);
        else{
          print('can\'t cancel the booking');
        }
      });
    });

  }

  _extendBooking() {

  }

  double _getProgress() {
    String start = widget._booking.beginDate;
    String end = widget._booking.endDate;
    DateTime now = DateTime.now();
    if (start != null && end != null) {
      try {
        DateTime startTime = DateTime.parse(start);
        DateTime endTime = DateTime.parse(end);
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          int totalTime = endTime.difference(startTime).inSeconds;
          int consumedTime = now.difference(startTime).inSeconds;
          double progress = ((consumedTime * 100) / totalTime).toDouble();
          return progress;
        } else if(now.isBefore(startTime)) {
          return .0;
        }else return 1.0;

      } catch (e) {
        print('date parsing error: $e');
      }
    }
    return .0;
  }

  String _getRemainingTime() {
    Duration remaining;
    String start = widget._booking.beginDate;
    String end = widget._booking.endDate;
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
      print("error parsing leaving time in booking list $e");
      remaining = Duration();
    }

    String remainingTime;
    if (remaining.isNegative || remaining.inMinutes == 0) {
      setState(() {
        _isTimeUp = true;
      });
      remainingTime = '00 : 00 : 00';
    } else {
      int hours = (remaining.inMinutes ~/ 60);
      int minutes = (remaining.inMinutes % 60);
      int seconds = (remaining.inSeconds % 3600);

      String hoursAsString = (hours < 10) ? '0$hours' : hours.toString();
      String minutesAsString =
          (minutes < 10) ? '0$minutes' : minutes.toString();
      String secAsString = (seconds < 10) ? '0$seconds' : seconds.toString();

      remainingTime = '$hoursAsString : $minutesAsString : $secAsString';
    }

    return remainingTime;
  }

  _startCountDown() {
    try {
      const oneSec = const Duration(seconds: 1);
      Timer.periodic(oneSec, (Timer t) {
        if (_isTimeUp) {
          t.cancel();
        } else {
          setState(() {
            _progress = _getProgress();
            _remainingTime = _getRemainingTime();
          });
        }
      });
    } catch (e) {
      print('contDown error $e');
    }
  }
}
