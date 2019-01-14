import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/common/timer_picker_util.dart';
import 'package:desk4work/view/filter/date_filter.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/place_filter.dart';
import 'package:desk4work/view/filter/time_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FilterMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterMainScreenState();
}

class FilterMainScreenState extends State<FilterMainScreen> {
  Size _screenSize;
  double _screenHeight;
  double _screenWidth;
  StringResources _stringResources;
  Filter filter;
  FilterStateContainerState _container;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool _isTheNextDay;
  bool _isStart;
  int _defaultMinutes;
  ExpansionTile _timeTile;
  @override
  void initState() {
    super.initState();
    _isTheNextDay = false;
    _isStart =true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(filter?.startHour!=null){
        try{
          setState(() {
            _defaultMinutes = int.parse(filter.startHour.substring(filter.startHour.indexOf(':')+1));
          });
        }catch(e){
          print('default minutes error: $e');
        }
      }
      _container.getFilter();
      _checkNextDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    final double textFilterParameterHeight = (_screenHeight * .0599);
    final double textFilterParameterWidth = (_screenWidth * .43);
    final double placeNumberFilerWidth = (_screenWidth * .336);
    final double confirmButtonHeight = (_screenHeight * .0824);
    final double confirmButtonWidth = (_screenWidth * .84);

    _stringResources = StringResources.of(context);
    final container = FilterStateContainer.of(context);
    filter = container.filter;
    _container = container;

    String date = (filter != null && filter.date != null)
        ? filter.date[0].substring(0, 5) + ((filter.date.length <2) ?"" : "-" + filter.date[1].substring(0, 5))
        : _getFilterDate(DateTime.now());

    return Theme(
      data: ThemeUtil.getThemeForWhiteBackground(context) ,
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          leading: Center(child: InkWell(
            child: Text(_stringResources.tClear, style: TextStyle(color: Colors.white)),
            onTap: () {
              _clearFilter();
            },
          ),),
          title: Text(_stringResources.tFilter, style: TextStyle(color: Colors.white),),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close, color: Colors.white,),
                onPressed: () {
                  _closeFilter();
                }),
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: (_screenHeight * .029)),
              ),
              new Row(
                children: <Widget>[
                  Expanded(child: InkWell(
                    child: Container(
                      height: textFilterParameterHeight,
                      width: textFilterParameterWidth,
                      padding: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecorationUtil
                          .getGreyRoundedCornerBoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.place),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                          ),
                          Container(
                            width: textFilterParameterWidth - 40,
                            child: Text(
                              (filter?.place ?? _stringResources.hPlace),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _openPlaceSearch(context);
                    },
                  ),)
                ],
              ),
              Divider(),
              new Row(children: <Widget>[
                Expanded(child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    height: textFilterParameterHeight,
                    width: textFilterParameterWidth,
                    decoration: BoxDecorationUtil
                        .getGreyRoundedCornerBoxDecoration(),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                        ),
                        Text(date)
                      ],
                    ),
                  ),
                  onTap: () {
                    _openDatePicker();
                  },
                ))
              ],),
              new Row(children: <Widget>[
                Expanded(child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    height: textFilterParameterHeight,
                    width: textFilterParameterWidth,
                    decoration: BoxDecorationUtil
                        .getGreyRoundedCornerBoxDecoration(),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                        ),
                        Text(date)
                      ],
                    ),
                  ),
                  onTap: () {
                    _openDatePicker();
                  },
                ))
              ],),
              Divider(),

              ExpansionTile(
                leading: Icon(Icons.access_time),
                title: Text(_stringResources.hStart),
                trailing: Text((filter?.startHour ??
                    " ")),
                children: <Widget>[
                  _buildTimePicker(true)
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.access_time),
                title: Text(_stringResources.hEnd),
                trailing: Text((filter?.endHour ??
                    " ")),
                children: <Widget>[
                  _buildTimePicker(false)
                ],
              ),
              new InkWell(
                onTap: () {
                  _openTimePicker(true);
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: textFilterParameterHeight,
                      width: textFilterParameterWidth,
                      decoration: BoxDecorationUtil
                          .getGreyRoundedCornerBoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                          ),
                          Text(_stringResources.hStart)
                        ],
                      ),
                    ),
                    Text((filter?.startHour ??
                        " "))
                  ],
                ),
              ),
              new InkWell(
                onTap: () {
                  _openTimePicker(false);
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: textFilterParameterHeight,
                      width: textFilterParameterWidth,
                      decoration: BoxDecorationUtil
                          .getGreyRoundedCornerBoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                          ),
                          Text(_stringResources.hEnd)
                        ],
                      ),
                    ),
                    Text((filter?.endHour ??
                        " "))
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecorationUtil.getOrangeRoundedCornerBoxDecoration(),
                        child: Container(),
                      ),
                      IconButton(
                          icon: Icon(Icons.remove, color: Colors.white,),
                          onPressed: () {
                            _reducePlaces();
                          }),

                    ],
                  ),

                  Container(
                      height: textFilterParameterHeight,
                      width: placeNumberFilerWidth,
                      decoration: BoxDecorationUtil
                          .getGreyRoundedCornerBoxDecoration(),
                      child: Center(
                        child: Text("${filter?.numberOfSeatsNeeded ?? 1} "
                            "${_stringResources.hPlace}"),
                      )),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecorationUtil.getOrangeRoundedCornerBoxDecoration(),
                        child: Container()
                      ),
                      IconButton(
                          icon: Icon(Icons.add, color: Colors.white,),
                          onPressed: () {
                            _addPlaces();
                          }),
                    ],
                  ),

                ],
              ),
              Divider(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.printerNeeded ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(printerNeeded: value);
                  }),
                  Text(_stringResources.tPrint),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.teaOrCoffeeNeeded ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(teaOrCoffeeNeeded: value);
                  }),
                  Text(_stringResources.tTeaOrCoffee),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.parkingNeeded ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(parkingNeeded: value);
                  }),
                  Text(_stringResources.tParkingNeeded),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.kitchenNeeded ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(kitchenNeeded: value);
                  }),
                  Text(_stringResources.tKitchen),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.freeParkingNeeded ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(freeParkingNeeded: value);
                  }),
                  Text(_stringResources.tFreeParkingNeeded),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: filter?.freePrinter ?? false,
                      onChanged: (value){
                    _container.updateFilterInfo(freePrinterNeeded: value);
                  }),
                  Text(_stringResources.tFreePrinter),
                ],
              ),
              Container(
                margin: EdgeInsets.all(24.0),
                width: confirmButtonWidth,
                height: confirmButtonHeight,
                decoration:
                BoxDecorationUtil.getOrangeGradientRoundedCornerDecoration(),
                child: InkWell(
                  onTap: () {
                    _search();
                  },
                  child: Center(
                    child: Text(
                      _stringResources.bConfirm,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),



//              new Container(
//                padding: EdgeInsets.symmetric(
//                    horizontal: (_screenWidth * .048).toDouble()),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//
//
////                    Padding(
////                      padding: EdgeInsets.only(top: (_screenHeight * .036)),
////                    ),
////                    Center(
////                      child: Text(_stringResources.tComfort),
////                    ),
//                    GridView.count(
//                      shrinkWrap: true,
//                      crossAxisCount: 3,
//                      children: <Widget>[
////                      _getRoundedIconButton(
////                          Icons.print,
////                          _stringResources.tPrint,
////                          (filter?.printerNeeded ?? false), () {
////                        _container.updateFilterInfo(
////                            printerNeeded: (filter != null)
////                                ? !filter.printerNeeded
////                                : true);
////                      }),
//
//                        _getRoundedIconButton(
//                            Icons.local_cafe,
//                            _stringResources.tTeaOrCoffee,
//                            (filter?.teaOrCoffeeNeeded ?? false), () {
//                          _container.updateFilterInfo(
//                              teaOrCoffeeNeeded: (filter != null)
//                                  ? !filter.teaOrCoffeeNeeded
//                                  : true);
//                        }),
//                        _getRoundedIconButton(
//                            Icons.local_parking,
//                            _stringResources.tParkingNeeded,
//                            (filter?.parkingNeeded ?? false), () {
//                          container.updateFilterInfo(
//                              parkingNeeded: (filter != null)
//                                  ? !filter.parkingNeeded
//                                  : true);
//                        }),
//                        _getRoundedIconButton(
//                            Icons.local_dining,
//                            _stringResources.tKitchen,
//                            (filter?.kitchenNeeded ?? false), () {
//                          container.updateFilterInfo(
//                              kitchenNeeded: (filter != null)
//                                  ? !filter.kitchenNeeded
//                                  : true);
//                        }),
//                        _getRoundedIconButtonFromPng(
//                            'assets/free_printing_orange.png',
//                            'assets/free_printing.png',
//                            _stringResources.tFreePrinter,
//                            (filter?.freePrinter ?? false), () {
//                          container.updateFilterInfo(
//                              freePrinterNeeded: (filter != null)
//                                  ? !filter.freePrinter
//                                  : true);
//                        }),
//                        _getRoundedIconButtonFromPng(
//                            'assets/free_parking_orange.png',
//                            'assets/free_parking_white.png',
//                            _stringResources.tFreeParkingNeeded,
//                            (filter?.freeParkingNeeded ?? false), () {
//                          container.updateFilterInfo(
//                              freeParkingNeeded: (filter != null)
//                                  ? !filter.freeParkingNeeded
//                                  : true);
//                        }),
//                      ],
//                    ),
//
//                  ],
//                ),
//              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCalendar(bool isStartDate){

  }

  Widget _buildTimePicker(bool isStartTime){
    return Container(
      height: _screenHeight * .3219,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: Duration(
            hours: (isStartTime)
                ? _getTimePickerStart()<24 ? _getTimePickerStart() : 1
                : _getTimePickerEnd()<24 ? _getTimePickerEnd() : 1,
            minutes: _defaultMinutes ?? DateTime.now().minute
        ),
        onTimerDurationChanged: (duration) {
          String hh = (duration.inMinutes / 60).truncate().toString();
          if (int.parse(hh) < 10) hh = '0' + hh;
          String mm = (duration.inMinutes % 60).toString();
          if (int.parse(mm) < 10) mm = '0' + mm;
          if (isStartTime) {
            setState(() {
              int hour = int.parse(hh);
//                          _tempStart = "$hour:$mm";
              _container.updateFilterInfo(startHour:"$hour:$mm" );
            });
          } else {
            int hour = int.parse(hh);
            _container.updateFilterInfo(endHour:"$hour:$mm");
//                        setState(() {
//                          _tempEnd = "$hour:$mm";
//                        });
          }
        },
      ),
    );
  }

  void _clearFilter() {
    _container.clearFilter();
  }

  void _closeFilter() {
    Navigator.of(context).pop([false]);
  }

  void _search() {
    String prefix = _stringResources.tFilterSettingsPrefix;
    String suffix = _stringResources.tFilterSettingsSuffix;

    Navigator.of(context).pop([true, filter]);
  }

  _showMessage(String message) {
    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _openPlaceSearch(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlaceFilterScreen(filter?.place)));
    if (result != null) {
      _container.updateFilterInfo(latLong: result);
    }
  }


  void _openDatePicker() {
    List<DateTime> dates= _getDatesFromFilter();
    Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => DateFilterScreen(dates)))
        .then((dates) {
      if (dates != null && dates.length > 0) {
        List<String> filterDates = [];

        String dateTimeStart = _getFilterDate(dates[0]);
        String dateTimeEnd = _getFilterDate(dates[dates.length - 1]);


        filterDates.add(dateTimeStart);
        if(dates[0] != dates[dates.length - 1])
          filterDates.add(dateTimeEnd);
        _container.updateFilterInfo(date: filterDates);
        _checkNextDay();
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
  
  List<DateTime> _getDatesFromFilter(){
    List<DateTime> dates = [];
    if(filter !=null && filter.date != null){
      filter.date.forEach((string){
        String year = string.substring(6);
        String month = string.substring(3,5);
        String day = string.substring(0,2);
        dates.add(DateTime.parse('$year$month$day'));
      });
    }
    return dates;
  }

  void _openTimePicker(bool isForStartTime) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TimeFilterScreen(
                    filter?.startHour, filter?.endHour, isForStartTime)))
        .then((result) {
      if (result != null) {
        String toParseStart = result[0];
        if (toParseStart != null && toParseStart.length < 5)
          toParseStart = '0' + toParseStart;

        String toParseEnd = result[1];
        if (toParseEnd != null && toParseEnd.length < 5)
          toParseEnd = '0' + toParseEnd;
        int start = int.parse(toParseStart?.substring(0, 2) ?? '0');
        int end = int.parse(toParseEnd?.substring(0, 2) ?? '0');
        _container.updateFilterInfo(startHour: result[0], endHour: result[1]);
        _checkNextDay();
      }
    });
  }

  void _addPlaces() {
    int places = (filter != null) ? filter.numberOfSeatsNeeded : 1;
    places++;
    _container.updateFilterInfo(numberOfSeatsNeeded: places);
  }

  _checkNextDay(){
    if(filter !=null){
      int startHour = int.parse(filter.startHour.substring(0,filter.startHour.indexOf(':')));
      int endHour = int.parse(filter.endHour.substring(0,filter.endHour.indexOf(':')));
      int endMinutes = int.parse(filter.endHour.substring(filter.endHour.indexOf(':')+1));
      int startMinutes = int.parse(filter.startHour.substring(filter.startHour.indexOf(':')+1));

      if(filter.date ==null || filter.date.length <2){
        if((endHour < startHour) || (endHour == startHour && endMinutes <= startMinutes)){
          setState(() {
            _isTheNextDay = true;
          });
        }else{
          setState(() {
            _isTheNextDay = false;
          });
        }
      }
    }



  }

  void _reducePlaces() {
    int places = filter?.numberOfSeatsNeeded ?? 1;
    places--;
    _container.updateFilterInfo(numberOfSeatsNeeded: places > 0 ? places : 1);
  }

  Widget _getRoundedIconButton(
      IconData icon, String caption, bool isSelected, Function onPressed) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: (_screenWidth * .128).toDouble(),
            height: (_screenHeight * .072).toDouble(),
            child: FloatingActionButton(
              heroTag: caption,
              onPressed: onPressed,
              backgroundColor: isSelected ? Colors.white : Colors.transparent,
              child:
                  Icon(icon, color: isSelected ? Colors.orange : Colors.white),
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              elevation: 0.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (_screenHeight * .009)),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }


  Widget _getRoundedIconButtonFromPng(
      String urlClicked,String urlUnclicked, String caption, bool isSelected, Function onPressed) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: (_screenWidth * .128).toDouble(),
            height: (_screenHeight * .072).toDouble(),
            child: FloatingActionButton(
              heroTag: caption,
              onPressed: onPressed,
              backgroundColor: isSelected ? Colors.white : Colors.transparent,
              child:
              Image.asset(isSelected ? urlClicked : urlUnclicked, fit: BoxFit.contain, width: 24.0, height: 24.0,),
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              elevation: 0.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (_screenHeight * .009)),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }


  int _getTimePickerStart() {

    if (filter?.startHour == null) {
      return DateTime.now().hour;
    } else {
      print('time before crashhh: ${filter.startHour}');
      return (filter.startHour.length > 4)
          ? int.parse(filter.startHour.substring(0, 2))
          : int.parse(filter.startHour.substring(0,1));
    }
  }

  int _getTimePickerEnd() {
    if (filter.startHour == null && filter.endHour == null) {
      return _getTimePickerStart() + 2;
    } else if (filter.endHour == null) {
      return (filter.startHour.length > 4)
          ? int.parse(filter.startHour.substring(0, 2))
          : int.parse(filter.startHour.substring(0,1));
    } else {
      return (filter.endHour.length > 4)
          ? int.parse(filter.endHour.substring(0, 2))
          : int.parse(filter.endHour.substring(0,1));
    }
  }

}
