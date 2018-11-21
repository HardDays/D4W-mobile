import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/filter/date_filter.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/time_filter.dart';
import 'package:desk4work/view/main/booking_details.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBookingScreen extends StatefulWidget {
  final CoWorking _coWorking;

  NewBookingScreen(this._coWorking);

  @override
  State<StatefulWidget> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  double _screenWidth, _screenHeight;
  StringResources _stringResources;
  double _textFilterParameterHeight;

  double _textFilterParameterWidth;

  double _placeNumberFilerWidth;
  double _confirmButtonHeight;

  double _confirmButtonWidth;

  String _screenDate, _starWork, _endWork, _serverDate;
  int _neededNumberOfSeats, _availableSeats;
  num _price;
  BookingApi _bookingApi;
  GlobalKey<ScaffoldState> _screenState = GlobalKey<ScaffoldState>();
  int _startHour, _endHour;
  bool _isLoading;
  DateTime _selectedDate;

  @override
  void initState() {
    DateTime now = DateTime.now();
    int time =(now.hour < 23)? now.hour + 1 : 1;
    int min = now.minute;
    String timeStartString = (time < 10) ? '0$time' : time.toString();
    String minString = (min < 10) ?  '0$min': min.toString();

    int timeEnd = (time < 23) ? time + 1 : 1;
    String timeEndString = (timeEnd < 10) ? '0$timeEnd' : timeEnd.toString();

    _starWork = FilterStateContainerState.getDefaultStartHour();
    _endWork = FilterStateContainerState.getDefaultEndHour();

    _isLoading = false;
    _selectedDate = DateTime.now();
    _serverDate =
    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    _screenDate = _getFilterDate(DateTime.now());
    _availableSeats = widget._coWorking.freeSeats;
    _neededNumberOfSeats = 1;
    _bookingApi = BookingApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _screenWidth = screenSize.width;
    _screenHeight = screenSize.height;
    _textFilterParameterHeight = (_screenHeight * .0599);
    _textFilterParameterWidth = (_screenWidth * .43);
    _placeNumberFilerWidth = (_screenWidth * .336);
    _confirmButtonHeight = (_screenHeight * .0824);
    _confirmButtonWidth = (_screenWidth * .84);

    _stringResources = StringResources.of(context);
    _price = _getTimeCoefficient() * _neededNumberOfSeats * widget._coWorking.price;

    Gradient orangeBoxDecorationGradient =
        BoxDecorationUtil.getDarkOrangeGradient().gradient;

    return Theme(
      data: ThemeUtil.getThemeForOrangeBackground(context),
      child: Scaffold(
        key: _screenState,
        body: Container(
          decoration: BoxDecoration(
              gradient: orangeBoxDecorationGradient,
              border: BorderDirectional(
                  bottom: BorderSide(color: Colors.grey, width: .5))),
          child: (_isLoading)
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: (_screenHeight * .0308).toDouble(),
//                 right: (_screenWidth * .04)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: _screenWidth * .064),
                      child: Column(
                        children: <Widget>[
                          _buildFourUpperWidgets(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: (_screenHeight * .036)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _reducePlaces();
                                  }),
                              InkWell(
                                child: Container(
                                    height: _textFilterParameterHeight,
                                    width: _placeNumberFilerWidth,
                                    decoration: BoxDecorationUtil
                                        .getGreyRoundedCornerBoxDecoration(),
                                    child: Center(
                                      child: Text(
                                        '${_neededNumberOfSeats.toString()} '
                                            '${_stringResources.hPlace}',
                                      ),
                                    )),
                              ),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _addPlaces();
                                  })
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: (_screenHeight * .036)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color: Colors.white, width: .5))),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: (_screenHeight * .036)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_stringResources.tPrice + ':'),
                              Text(_price.toString() + " ₽")
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _screenHeight * .15)),
                          Container(
                            width: _confirmButtonWidth,
                            height: _confirmButtonHeight,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28.0))),
                            child: InkWell(
                              onTap: () {
                                _book();
                              },
                              child: Center(
                                child: Text(
                                  _stringResources.bConfirm,
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFourUpperWidgets() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            widget._coWorking.shortName,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: (_screenWidth * .036).toDouble()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(
                vertical: _screenHeight * .045,
              )),
              Container(
                height: _textFilterParameterHeight,
                width: _textFilterParameterWidth,
                padding: EdgeInsets.only(left: 8.0),
                decoration:
                    BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.place),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                    ),
                    Container(
                      width: _screenWidth * .288,
                      child: Text(
                        widget._coWorking.address,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: .75,
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  height: _textFilterParameterHeight,
                  width: _textFilterParameterWidth,
                  decoration:
                      BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Text(_screenDate ?? _stringResources.hDate)
                    ],
                  ),
                ),
                onTap: () {
                  _openDatePicker();
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: (_screenHeight * .021)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  height: _textFilterParameterHeight,
                  width: _textFilterParameterWidth,
                  decoration:
                      BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Text((_starWork ?? _stringResources.hStart))
                    ],
                  ),
                ),
                onTap: () {
                  _openTimePicker(true);
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  height: _textFilterParameterHeight,
                  width: _textFilterParameterWidth,
                  decoration:
                      BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Text((_endWork ?? _stringResources.hEnd))
                    ],
                  ),
                ),
                onTap: () {
                  _openTimePicker(false);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void _openDatePicker() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => DateFilterScreen(
                  [_selectedDate],
                  isMultiple: false,
                ))).then((dates) {
      if (dates != null && dates.length > 0) {
        print('format ${dates[0]}');

        String dateTimeStart = _getFilterDate(dates[0]);

        setState(() {
          _screenDate = dateTimeStart;
          DateTime serverDate = dates[0];
          _selectedDate = serverDate;

          _serverDate =
              '${serverDate.year}-${serverDate.month}-${serverDate.day}';
        });
//        _container.updateFilterInfo(date: filterDates); TODO
      }
    });
  }

  String _getFilterDate(DateTime dateTime) {
    int dayInt = dateTime.day;
    String day = (dayInt < 10) ? "0$dayInt" : dayInt.toString();
    int montInt = dateTime.month;
    String month = (montInt < 10) ? "0$montInt" : montInt.toString();
    String year = dateTime.year.toString();
    return "$day.$month.$year";
  }

  void _openTimePicker(bool isForStartTime) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TimeFilterScreen(_starWork, _endWork, isForStartTime)))
        .then((result) {
      if (result != null) {
        setState(() {
          _starWork = result[0] ?? _starWork;
          _endWork = result[1] ?? _endWork;
        });
      }
    });
  }

  void _addPlaces() {
    if (_neededNumberOfSeats < _availableSeats)
      setState(() {
        _neededNumberOfSeats++;
      });
  }

  void _reducePlaces() {
    if (_neededNumberOfSeats > 1)
      setState(() {
        _neededNumberOfSeats--;
      });
  }

  int _getTimeCoefficient(){
    bool isStartTimeSet = _starWork !=null && _starWork.length >2;
    bool isEndTimeSet = _endWork !=null && _endWork.length >2;

    int startHour = isStartTimeSet ? int.parse(_starWork.substring(0, _starWork.indexOf(':'))) : 0;
    int endHour = isStartTimeSet ?  int.parse(_endWork.substring(0, _endWork.indexOf(':'))) : 0;
    int startMin = isEndTimeSet ? int.parse(_starWork.substring(_starWork.indexOf(':')+1)) : 0;
    int endMin = isEndTimeSet ? int.parse(_endWork.substring(_endWork.indexOf(':')+1)) : 0;

    int dayEnd = (startHour > endHour) ? 2 : 1;
    Duration difference = DateTime(2000,1,dayEnd,endHour, endMin).difference(DateTime(2000,1,1,startHour, startMin));
    int differenceInMin = difference.inMinutes.abs();
    int differenceInHours = (differenceInMin /60).ceil();

    differenceInHours = differenceInHours > 0 ? differenceInHours : 1;

    return differenceInHours;

  }

  void _book() {
    if (_serverDate != null &&
        _starWork != null &&
        _endWork != null &&
        _neededNumberOfSeats != null) {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences.getInstance().then((sp) {
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        _bookingApi
            .book(token, widget._coWorking.id, _neededNumberOfSeats, _starWork,
                _endWork, _serverDate)
            .then((booking) {
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
                      _stringResources.mBookingRequestSentPrefix +
                          ' ${widget._coWorking.shortName ?? " " + _stringResources.mBookingRequestSentSuffix}',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                          highlightColor: Colors.orange,
                          color: Colors.white,
                          textColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(21.0)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ).then((_) {
            _openBookinList();
          });
        }).catchError((error) {
          setState(() {
            _isLoading = false;
          });
          print('error type: ${error.runtimeType}');
          if (error.runtimeType == ArgumentError) {
            ArgumentError invalidError = error;
            List errorMessage = invalidError.message;
            if (errorMessage[0]['begin_date'] != null) {
              _showMessage(_stringResources.eWrongStartDate);
            } else if (errorMessage[0]['end_date'] != null) {
              _showMessage(_stringResources.eWrongEndDate);
            }else _showMessage(_stringResources.eServer);
          }
        });
      });
    } else if (_serverDate == null) {
      _showMessage(_stringResources.eWrongStartDate);
    }
  }

  _openBookinList() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => MainScreen(
                  firstTab: 1,
                ))
//                  builder: (ctx)=> BookingDetails(booking))
        );
  }

  _showMessage(String message) {
    _screenState.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
