import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/common/timer_picker_util.dart';
import 'package:flutter/material.dart';

class TimeFilterScreen extends StatefulWidget {
  final String _startTime, _endTime;
  final bool _isStart;

  TimeFilterScreen(this._startTime, this._endTime, this._isStart);

  @override
  State<StatefulWidget> createState() => TimeFilterState();
}

class TimeFilterState extends State<TimeFilterScreen> {
  StringResources _stringResources;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  String _tempStart, _tempEnd;
  double _confirmButtonHeight;
  double _confirmButtonWidth;
  bool _isStart;
  int _defaultMinutes;

  @override
  void initState() {
    _tempStart = widget._startTime;
    _tempEnd = widget._endTime;
    _isStart = widget._isStart;
    if(_tempStart!=null){
      try{
        _defaultMinutes = int.parse(_tempStart.substring(_tempStart.indexOf(':')+1));
      }catch(e){
        print('default minutes error: $e');
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tempStart == null) _getDefaultStart();

      if (_tempEnd == null) _getDefaultEnd();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    final double textFilterParameterHeight = (_screenHeight * .0599);
    final double textFilterParameterWidth = (_screenWidth * .43);
    _confirmButtonHeight = (_screenHeight * .0824);
    _confirmButtonWidth = (_screenWidth * .84);
    return Theme(
      data: ThemeUtil.getThemeForOrangeBackground(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecorationUtil.getDarkOrangeGradient(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: (_screenHeight * .0308).toDouble(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BackButton(),
                    Text(_stringResources.tFilter),
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          _validate();
                        }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: (_screenHeight * .029)),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: (_screenWidth * .048).toDouble()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isStart = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        height: textFilterParameterHeight,
                        width: textFilterParameterWidth,
                        decoration: _isStart
                            ? BoxDecorationUtil
                                .getGreyRoundedWhiteCornerBoxDecoration()
                            : BoxDecorationUtil
                                .getGreyRoundedCornerBoxDecoration(),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.access_time),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                            ),
                            Text((_tempStart ?? _stringResources.hStart))
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          _isStart = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        height: textFilterParameterHeight,
                        width: textFilterParameterWidth,
                        decoration:
                        !_isStart
                            ? BoxDecorationUtil
                            .getGreyRoundedWhiteCornerBoxDecoration()
                            : BoxDecorationUtil
                            .getGreyRoundedCornerBoxDecoration(),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.access_time),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                            ),
                            Text((_tempEnd ?? _stringResources.hEnd))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: (_screenHeight * .132)),
              ),
              Container(
                height: (_screenHeight * .3253).toDouble(),
                padding: EdgeInsets.symmetric(vertical: (_screenHeight * .029)),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                      hours: (_isStart)
                          ? _getTimePickerStart()<24 ? _getTimePickerStart() : 1
                          : _getTimePickerEnd()<24 ? _getTimePickerEnd() : 1,
                    minutes: _defaultMinutes ?? DateTime.now().minute
                  ),
                  onTimerDurationChanged: (duration) {
                    String hh = (duration.inMinutes / 60).truncate().toString();
                    if (int.parse(hh) < 10) hh = '0' + hh;
                    String mm = (duration.inMinutes % 60).toString();
                    if (int.parse(mm) < 10) mm = '0' + mm;
                    if (_isStart) {
                      setState(() {
                        int hour = _getStart(int.parse(hh));
                        _tempStart = "$hour:$mm";
                      });
                    } else {
                      setState(() {
                        int hour = _getEndTime(int.parse(hh));
                        _tempEnd = "$hour:$mm";
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: (_screenHeight * .0974)),
              ),
              _getSaveButton()
            ],
          ),
        ),
      ),
    );
  }

  int _getEndTime(int selected) {
//    int start = 0;
//    try {
//      if (widget._startTime != null) {
//        start = (widget._startTime.length > 1)
//            ? int.parse(widget._startTime.substring(0, 2))
//            : int.parse(widget._startTime.substring(0));
//
//        if (start >= selected) selected = start + 1;
//      }
//    } catch (e) {
//      print('parsing time start error $e');
//    }
//    if (selected < 10) selected = 10;
    return selected;
  }

  int _getStart(int selected) {
//    if(selected > 17)
//      selected --;
//    if(selected <9)
//      selected = 9;
    return selected;
  }

  Widget _getSaveButton() {
    return Center(
      child: Container(
        width: _confirmButtonWidth,
        height: _confirmButtonHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28.0))),
        child: InkWell(
          onTap: () {
            _validate();
          },
          child: Center(
            child: Text(
              _stringResources.bSave.toUpperCase(),
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
      ),
    );
  }

  _getDefaultStart() {
    DateTime dateTime = DateTime.now();
    int hour = dateTime.hour;
    int minutes = dateTime.minute;
    String stringHour = hour > 9 ? hour.toString() : '0$hour';
    String stringMinutes = minutes > 9 ? minutes.toString() : '0$minutes';

    setState(() {
      _tempStart = stringHour + ':' + stringMinutes;
    });
  }

  int _getTimePickerStart() {

    if (_tempStart == null) {
      return DateTime.now().hour;
    } else {
      print('time before crashhh: $_tempStart');
      return (_tempStart.length > 4)
          ? int.parse(_tempStart.substring(0, 2))
          : int.parse(_tempStart.substring(0,1));
    }
  }


  int _getTimePickerEnd() {
    if (_tempStart == null && _tempEnd == null) {
      return _getTimePickerStart() + 2;
    } else if (_tempEnd == null) {
      return (_tempStart.length > 4)
          ? int.parse(_tempStart.substring(0, 2))
          : int.parse(_tempStart.substring(0,1));
    } else {
      return (_tempEnd.length > 4)
          ? int.parse(_tempEnd.substring(0, 2))
          : int.parse(_tempEnd.substring(0,1));
    }
  }

  _getDefaultEnd() {
    if (_tempStart == null) {
      DateTime dateTime = DateTime.now();
      int hour =(dateTime.hour <22) ? dateTime.hour + 2 : 1;
      int minutes = dateTime.minute;
      String stringHour = hour > 9 ? hour.toString() : '0$hour';
      String stringMinutes = minutes > 9 ? minutes.toString() : '0$minutes';
      setState(() {
        _tempEnd = stringHour + ':' + stringMinutes;
      });
    }else{
      int timePickerEnd = _getTimePickerEnd();
      timePickerEnd =(timePickerEnd <22) ? timePickerEnd : timePickerEnd -2;
      setState(() {

        _tempEnd = (timePickerEnd + 2).toString() +':'+ '00';
      });
    }
  }

  void _chooseEndTime(String startTime) {
    setState(() {
      _tempStart = startTime;
    });
  }

  void _chooseStartTime(String endTime) {
    setState(() {
      _tempEnd = endTime;
    });
  }

  void _validate() {
    Navigator.pop(context, {0: _tempStart, 1: _tempEnd});
  }
}
