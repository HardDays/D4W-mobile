import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/filter/date_filter.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/time_filter.dart';
import 'package:flutter/material.dart';

class NewBookingScreen extends StatefulWidget{
  final CoWorking _coWorking;


  NewBookingScreen(this._coWorking);

  @override
  State<StatefulWidget> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen>{
  Filter _filter;
  double _screenWidth, _screenHeight;
  StringResources _stringResources;
  double _textFilterParameterHeight ;
  double _textFilterParameterWidth ;
  double _placeNumberFilerWidth;
  double _confirmButtonHeight ;
  double _confirmButtonWidth ;
  String _date, _starWork, _endWork;
  int _neededNumberOfSeats, _availableSeats;
  num _price;

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
    _date = _stringResources.hDate;
    _starWork = _stringResources.hStart;
    _endWork = _stringResources.hEnd;
    _availableSeats = widget._coWorking.freeSeats;
    _neededNumberOfSeats = 1;
    _price = _neededNumberOfSeats * widget._coWorking.price;

    Gradient orangeBoxDecorationGradient =
    BoxDecorationUtil.getDarkOrangeGradient().gradient;

   return Scaffold(
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
                 right: (_screenWidth * .04)),
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
                       child: Text(_neededNumberOfSeats.toString()),
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
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Text(_stringResources.tPrice + ':'),
               Text(_price.toString() + " ₽")
             ],
           ),
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
   );
  }


  Widget _buildFourUpperWidgets(){
    return Container(
      margin: EdgeInsets.only(
          top: _screenHeight * .0124,
          left: _screenWidth  * .08,
          right: _screenWidth  * .08,
          bottom: _screenHeight * .075
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget._coWorking.shortName,
            style: Theme.of(context).textTheme.headline,),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (_screenWidth * .048).toDouble()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                    Text(widget._coWorking.address)
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
                      Text(_date)
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
        List<String> filterDates = [];
        print('those are dates: $dates');

        String dateTimeStart = _getFilterDate(dates[0]);
        String dateTimeEnd = _getFilterDate(dates[dates.length -1 ]);


        print("Start $dateTimeStart and end $dateTimeEnd");
        filterDates.add(dateTimeStart);
        filterDates.add(dateTimeEnd);
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
//        _container.updateFilterInfo(
//            startHour: result[0],
//            endHour: result[1]);  TODO
      }
    });
  }

  void _addPlaces(){
    if(_neededNumberOfSeats < widget._coWorking.freeSeats)
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

  }
}