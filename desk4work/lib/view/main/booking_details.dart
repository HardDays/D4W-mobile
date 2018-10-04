import 'dart:async';

import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget{
  final Booking _booking;

  BookingDetails(this._booking);

  @override
  State<StatefulWidget> createState() =>_BookingDetailsState();

}

class _BookingDetailsState extends State<BookingDetails>{
  double _screenHeight, _screenWidth, _progress;
  bool _isTimeUp, _hasFreeMinutes;
  String _remainingTime;
  StringResources _stringResources;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Text(widget._booking.coWorking.shortName)),
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
    _progress = .0;
    _remainingTime = "00:00";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _startCountDown();
    });
  }

  Widget _buildHeader(List<String> imageIds){
    return Container(
      height: _screenHeight * .03238,
    );
  }

  Widget _buildProgressBar(){
    return Container(
      height: _screenHeight * .0045,
      child: LinearProgressIndicator(
        backgroundColor: Colors.orange,
        value: _progress,),
    );
  }

  Widget _buildStartEndWidget(){
    String startTime = widget._booking.beginWork;
    String endTime = widget._booking.endWork;

    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
            bottom: BorderSide(
                color: Colors.black26,
                width: .5))
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    startTime,
                    style: Theme.of(context).textTheme.headline,),
                  Text(
                    _stringResources.hStart,
                    style: Theme.of(context).textTheme.caption,)
                ],
              ),
            ),
            Container(decoration: BoxDecoration(
                border: BorderDirectional(
                    start: BorderSide(
                        color: Colors.black26,
                        width: .5))
            ),),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    endTime,
                    style: Theme.of(context).textTheme.headline,),
                  Text(
                    _hasFreeMinutes
                        ? _stringResources.tFreeMinutes
                        :_stringResources.hEnd,
                    style: Theme.of(context).textTheme.caption,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChronoWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            _remainingTime,
            style: Theme.of(context).textTheme.display3.copyWith(
                color: Colors.black),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                _stringResources.tHours,
                style: Theme.of(context).textTheme.caption,),
              Text(
                _stringResources.tMinutes,
                style: Theme.of(context).textTheme.caption,),
              Text(
                _stringResources.tSeconds,
                style: Theme.of(context).textTheme.caption,),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTerminatedExtendButton(){
    String buttonText = (_isTimeUp)
        ? _stringResources.tExtend
        : _stringResources.tTerminate;

    return Center(
      child: InkWell(
        child: Container(
          decoration: BoxDecorationUtil.getOrangeGradient(),
          child: Text(buttonText, style: Theme.of(context).textTheme.button,),
        ),
        onTap: (_isTimeUp) ? _extendBooking() : _terminateBooking(),
      ),
    );
  }

  _terminateBooking(){

  }

  _extendBooking(){}


  double _getProgress(){
    String endWork = widget._booking.endWork;
    String startWork = widget._booking.beginWork;
    double progress =  ((DateTime.parse(startWork).millisecondsSinceEpoch * 100)
        / DateTime.parse(endWork).millisecondsSinceEpoch ).toDouble();
    return progress;

  }

  String _getRemainingTime(){
    int remaining;
    try{
      remaining = DateTime.now()
          .difference(DateTime.parse(widget._booking.endWork)).inHours;
    }catch(e){
      print("error parsing leaving time in booking list $e");
      remaining = 0;
    }


    String remainingTime;
    if(remaining.isNegative || remaining == 0) {
      setState(() {
        _isTimeUp = true;
      });
      remainingTime = '00:00';
    }
    else {
      int hours = (remaining ~/ 24);
      int minutes = (remaining %24);
      remainingTime  = '$hours:$minutes';
    }

    return remainingTime;

  }

  _startCountDown(){
    const oneSec = const Duration(seconds:1);
    Timer.periodic(oneSec, (Timer t) {
     if(_isTimeUp){
       t.cancel();
     }else{
       setState(() {
         _progress = _getProgress();
         _remainingTime = _getRemainingTime();
       });
     }


    });
  }


}