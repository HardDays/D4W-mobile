import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/filter/date_filter.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/place_filter.dart';
import 'package:desk4work/view/filter/time_filter.dart';
import 'package:flutter/material.dart';

class FilterMainScreen extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => FilterMainScreenState();

}

class FilterMainScreenState extends State<FilterMainScreen>{
  Size _screenSize;
  double _screenHeight;
  double _screenWidth;
  StringResources _stringResources;
  Filter filter;
  FilterStateContainerState _container;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();



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

    String date= (filter !=null && filter.date !=null)
        ? filter.date[0].substring(0,5) +"-"+ filter.date[1].substring(0,5)
        : _stringResources.hDate;

    return Scaffold(
      key: _scaffoldState,
      body: Container(
        decoration: BoxDecorationUtil.getDarkOrangeGradient(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: (_screenHeight * .0308).toDouble(),
                  left: (_screenWidth * .04)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(_stringResources.tClear),
                    onTap: (){
                      _clearFilter();
                    },
                  ),
                  Text(_stringResources.tFilter),
                  IconButton(icon: Icon(Icons.close),
                      onPressed: (){
                        _closeFilter();
                      }),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: (_screenHeight * .029)),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: (_screenWidth * .048).toDouble()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: textFilterParameterHeight,
                          width: textFilterParameterWidth,
                          padding: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecorationUtil
                              .getGreyRoundedCornerBoxDecoration(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.place),
                              Padding(padding: EdgeInsets.only(left: 8.0),),
                              Text((filter?.place ?? _stringResources.hPlace))
                            ],
                          ),
                        ),
                        onTap: (){
                          _openPlaceSearch(context);
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          height: textFilterParameterHeight,
                          width: textFilterParameterWidth,
                          decoration: BoxDecorationUtil
                              .getGreyRoundedCornerBoxDecoration(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today),
                              Padding(padding: EdgeInsets.only(left: 8.0),),
                              Text(date)
                            ],
                          ),
                        ),
                        onTap: (){
                          _openDatePicker();
                        },
                      )
                    ],

                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (_screenHeight * .021)),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          height: textFilterParameterHeight,
                          width: textFilterParameterWidth,
                          decoration: BoxDecorationUtil
                              .getGreyRoundedCornerBoxDecoration(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.access_time),
                              Padding(padding: EdgeInsets.only(left: 8.0),),
                              Text((filter?.startHour ?? _stringResources.hStart))
                            ],
                          ),
                        ),
                        onTap: (){
                          _openTimePicker(true);
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          height: textFilterParameterHeight,
                          width: textFilterParameterWidth,
                          decoration: BoxDecorationUtil
                              .getGreyRoundedCornerBoxDecoration(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.access_time),
                              Padding(padding: EdgeInsets.only(left: 8.0),),
                              Text((filter?.endHour ?? _stringResources.hEnd))
                            ],
                          ),
                        ),
                        onTap: (){
                          _openTimePicker(false);
                        },
                      )
                    ],

                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (_screenHeight * .036)),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.remove
                      ), onPressed: (){
                        _reducePlaces();
                      }),
                      InkWell(
                        child: Container(
                            height: textFilterParameterHeight,
                            width: placeNumberFilerWidth,
                            decoration: BoxDecorationUtil
                                .getGreyRoundedCornerBoxDecoration(),
                            child: Center(
                              child: Text("${filter?.numberOfPlaces ?? 1} "
                                  "${ _stringResources.hPlace}"),
                            )
                        ),
                      ),
                      IconButton(icon: Icon(Icons.add
                      ), onPressed: (){
                        _addPlaces();
                      })
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (_screenHeight * .036)),),
                  Center(
                    child: Text(_stringResources.tComfort),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3, 
                    children: <Widget>[
                      _getRoundedIconButton(Icons.print,
                          _stringResources.tPrint,
                          ( filter?.printerNeeded ?? false),
                              (){
                        _container.updateFilterInfo(
                            printerNeeded: (filter !=null )
                                ? !filter.printerNeeded : true);
                        }),
                      _getRoundedIconButton(Icons.local_cafe,
                          _stringResources.tTeaOrCoffee,
                          ( filter?.teaOrCoffeeNeeded ?? false),
                              (){
                        _container.updateFilterInfo(
                            teaOrCoffeeNeeded: (filter != null)
                                ? !filter.teaOrCoffeeNeeded :true);
                          }),
                      _getRoundedIconButton(Icons.people,
                          _stringResources.tConferenceRoom,
                        (filter?.conferenceRoomNeeded ?? false),
                              (){
                        container.updateFilterInfo(
                            conferenceRoomNeeded: (filter !=null)
                                ? !filter.conferenceRoomNeeded : true);
                      }),
                      _getRoundedIconButton(Icons.local_dining,
                          _stringResources.tKitchen,
                          (filter?.kitchenNeeded ?? false),
                              (){
                            container.updateFilterInfo(
                                kitchenNeeded: (filter !=null)
                                    ? !filter.kitchenNeeded : true);
                          }),
                      _getRoundedIconButton(Icons.directions_bike,
                          _stringResources.tParkForBicycle,
                          (filter?.parkForBicycleNeeded ?? false),
                              (){
                            container.updateFilterInfo(
                                parkForBicycleNeeded: (filter !=null)
                                    ? !filter.parkForBicycleNeeded : true);
                          }),                      

                  ],
                  ),
                  Container(
                    width: confirmButtonWidth,
                    height: confirmButtonHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(28.0))
                    ),
                    child: InkWell(
                      onTap: (){
                        _search();
                      },
                      child: Center(
                        child: Text(_stringResources.bConfirm,
                          style: TextStyle(color: Colors.orange),),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void _clearFilter(){
    _container.updateFilterInfo();
  }

  void _closeFilter(){
    Navigator.of(context).pop([false]);
  }

  void _search(){
    String prefix = _stringResources.tFilterSettingsPrefix;
    String suffix = _stringResources.tFilterSettingsSuffix;
    if (filter != null){
      if(filter.place ==null)
        _showMessage(prefix + _stringResources.hPlace + suffix);
      else if(filter.date == null || filter.date.length <1)
        _showMessage(prefix + _stringResources.hDate + suffix);
      else if (filter.startHour == null)
        _showMessage(prefix + _stringResources.hStart + suffix);
      else if(filter.endHour == null)
        _showMessage(prefix + _stringResources.hEnd + suffix);
      else{
        Navigator.of(context).pop([true,filter]);
      }
    }
    }

  _showMessage(String message){
    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _openPlaceSearch(BuildContext context) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceFilterScreen(filter?.place))
    );
    if(result !=null) {
      _container.updateFilterInfo(latLong: result);
    }
  }

  void _openDatePicker(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx)=> DateFilterScreen())).then((dates){
          if(dates !=null && dates.length >0){
            List<String> filterDates = [];
            print('those are dates: $dates');

            String dateTimeStart = _getFilterDate(dates[0]);
            String dateTimeEnd = _getFilterDate(dates[dates.length -1 ]);


            print("Start $dateTimeStart and end $dateTimeEnd");
            filterDates.add(dateTimeStart);
            filterDates.add(dateTimeEnd);
            _container.updateFilterInfo(date: filterDates);
          }
    });
  }

  String _getFilterDate(DateTime dateTime){
    int dayInt = dateTime.day;
    String day = (dayInt < 10) ? "0$dayInt" : dayInt.toString();
    int montInt = dateTime.month;
    String month = (montInt < 10) ? "0$montInt" : montInt.toString();
    String year = dateTime.year.toString();
    return "$day.$month.$year";
  }
  void _openTimePicker(bool isForStartTime){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=> TimeFilterScreen(
                filter?.startHour,
                filter?.endHour, isForStartTime))).then((result){
      if(result !=null){
        int start = int.parse(result[0]?.substring(0,2) ?? '0')  ;
        int end = int.parse(result[1]?.substring(0,2) ?? '0');

        print('starrrrrrrrt $start end $end');
        _container.updateFilterInfo(
            startHour: result[0],
            endHour: result[1]);
      }
    });
  }

  void _addPlaces(){
    int places = (filter !=null )? filter.numberOfPlaces : 1;
    places ++;
    _container.updateFilterInfo(
        numberOfPlaces: places);
  }

  void _reducePlaces(){
    int places = filter?.numberOfPlaces ?? 1;
    places --;
    _container.updateFilterInfo(
        numberOfPlaces: places > 0 ? places : 1);
  }

  Widget _getRoundedIconButton(IconData icon, String caption, bool isSelected,
      Function onPressed){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: (_screenWidth * .128).toDouble(),
            height: (_screenHeight * .072).toDouble(),
            child: FloatingActionButton(
              heroTag: caption,
              onPressed: onPressed,
              backgroundColor: isSelected
                  ?Colors.white : Colors.transparent,
              child: Icon(icon,color: isSelected
                  ? Colors.orange : Colors.white),
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              elevation: 0.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: (_screenHeight * .009)),),
          Text(caption, textAlign: TextAlign.center,)
        ],
      ),
    );
  }


}