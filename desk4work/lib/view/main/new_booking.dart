import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/filter/date_filter.dart';
import 'package:desk4work/view/filter/time_filter.dart';
import 'package:desk4work/view/main/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBookingScreen extends StatefulWidget{
  final CoWorking _coWorking;


  NewBookingScreen(this._coWorking);

  @override
  State<StatefulWidget> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen>{
  double _screenWidth, _screenHeight;
  StringResources _stringResources;
  double _textFilterParameterHeight ;
  double _textFilterParameterWidth ;
  double _placeNumberFilerWidth;
  double _confirmButtonHeight ;
  double _confirmButtonWidth ;
  String _screenDate, _starWork, _endWork, _serverDate;
  int _neededNumberOfSeats, _availableSeats;
  num _price;
  BookingApi _bookingApi;


  @override
  void initState() {
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
    _price = _neededNumberOfSeats * widget._coWorking.price;

    Gradient orangeBoxDecorationGradient =
    BoxDecorationUtil.getDarkOrangeGradient().gradient;

   return Theme(
     data:  ThemeUtil.getThemeForOrangeBackground(context),
     child: Scaffold(
       body: Container(
         decoration: BoxDecoration(
           gradient: orangeBoxDecorationGradient,
           border: BorderDirectional(bottom: BorderSide(
               color: Colors.grey,
               width: .5))
         ),
         child: Column(

           children: <Widget>[
             Container(
               margin: EdgeInsets.only(top: (_screenHeight * .0308).toDouble(),
//                 right: (_screenWidth * .04)
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[
                   IconButton(icon: Icon(Icons.close),
                       onPressed: (){
                         Navigator.of(context).pop();
                       }),

                 ],
               ),
             ),
             Container(
               margin: EdgeInsets.symmetric(
                 horizontal: _screenWidth * .064
               ),
               child: Column(
                 children: <Widget>[
                   _buildFourUpperWidgets(),
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
                             height: _textFilterParameterHeight,
                             width: _placeNumberFilerWidth,
                             decoration: BoxDecorationUtil
                                 .getGreyRoundedCornerBoxDecoration(),
                             child: Center(
                               child: Text('${_neededNumberOfSeats.toString()} '
                                   '${_stringResources.hPlace
                               }',),
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
                   Container(
                     decoration: BoxDecoration(
                       border: BorderDirectional(
                           bottom: BorderSide(
                             color: Colors.white,
                             width: .5
                           ))
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(
                         top: (_screenHeight * .036)),),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text(_stringResources.tPrice + ':'),
                       Text(_price.toString() + " ₽")
                     ],
                   ),
                   Padding(padding: EdgeInsets.symmetric(
                       vertical: _screenHeight * .15)),
                   Container(
                     width: _confirmButtonWidth,
                     height: _confirmButtonHeight,
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(28.0))
                     ),
                     child: InkWell(
                       onTap: (){
                         _book();
                       },
                       child: Center(
                         child: Text(_stringResources.bConfirm,
                           style: TextStyle(color: Colors.orange),),
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


  Widget _buildFourUpperWidgets(){
    return Container(

      child: Column(
        children: <Widget>[
          Text(
            widget._coWorking.shortName,
            style: Theme.of(context)
                .textTheme.headline.copyWith(color: Colors.white),
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
                decoration: BoxDecorationUtil
                    .getGreyRoundedCornerBoxDecoration(),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.place),
                    Padding(padding: EdgeInsets.only(left: 8.0),),
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
                  decoration: BoxDecorationUtil
                      .getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Padding(padding: EdgeInsets.only(left: 8.0),),
                      Text(_screenDate ?? _stringResources.hDate)
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
                  height: _textFilterParameterHeight,
                  width: _textFilterParameterWidth,
                  decoration: BoxDecorationUtil
                      .getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Padding(padding: EdgeInsets.only(left: 8.0),),
                      Text((_starWork ?? _stringResources.hStart))
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
                  height: _textFilterParameterHeight,
                  width: _textFilterParameterWidth,
                  decoration: BoxDecorationUtil
                      .getGreyRoundedCornerBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Padding(padding: EdgeInsets.only(left: 8.0),),
                      Text((_endWork ?? _stringResources.hEnd))
                    ],
                  ),
                ),
                onTap: (){
                  _openTimePicker(false);
                },
              )
            ],

          ),
        ],
      ),
    );
  }



  void _openDatePicker(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx)=> DateFilterScreen())).then((dates){
      if(dates !=null && dates.length >0){

        print('format ${dates[0]}');


        String dateTimeStart = _getFilterDate(dates[0]);

        setState(() {
          _screenDate = dateTimeStart;
          DateTime serverDate = dates[0];

          _serverDate = '${serverDate.year}-${serverDate.month}-${serverDate.day}';
        });
//        _container.updateFilterInfo(date: filterDates); TODO
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
                _starWork,
                _endWork, isForStartTime))).then((result){
      if(result !=null){
        setState(() {
          _starWork =  result[0] ?? _starWork;
          _endWork = result[1] ?? _endWork;
        });

      }
    });
  }

  void _addPlaces(){
    if(_neededNumberOfSeats < _availableSeats)
      setState(() {
        _neededNumberOfSeats ++;
      });

  }

  void _reducePlaces(){
    if(_neededNumberOfSeats > 1)
      setState(() {
        _neededNumberOfSeats --;
      });
  }

  void _book(){
    if(_serverDate != null && _starWork != null && _endWork != null
        && _neededNumberOfSeats != null){
      SharedPreferences.getInstance().then((sp){
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        _bookingApi.book(token, widget._coWorking.id,
            _neededNumberOfSeats, _starWork, _endWork, _serverDate)
            .then((booking){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx)=> BookingDetails(booking)));
        });

      });
    }

  }
}