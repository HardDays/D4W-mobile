import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/common/timer_picker_util.dart';
import 'package:flutter/material.dart';

class TimeFilterScreen extends StatefulWidget{
  final String _startTime, _endTime;
  final bool _isStart;


  TimeFilterScreen(this._startTime, this._endTime, this._isStart);

  @override
  State<StatefulWidget> createState() => TimeFilterState();
}

class TimeFilterState extends State<TimeFilterScreen>{
  StringResources _stringResources;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  String _tempStart, _tempEnd;
  double _confirmButtonHeight;
  double _confirmButtonWidth;

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
                margin: EdgeInsets.only(top: (_screenHeight * .0308).toDouble(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BackButton(),
                    Text(_stringResources.tFilter),
                    IconButton(icon: Icon(Icons.check),
                        onPressed: (){
                          _validate();
                        }),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: (_screenHeight * .029)),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: (_screenWidth * .048).toDouble()),
                child: Row(
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
                          Padding(padding: EdgeInsets.only(left: 8.0),),
                          Text((widget._startTime ?? _tempStart ?? _stringResources.hStart))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: textFilterParameterHeight,
                      width: textFilterParameterWidth,
                      decoration: BoxDecorationUtil
                          .getGreyRoundedCornerBoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Padding(padding: EdgeInsets.only(left: 8.0),),
                          Text((widget._endTime ?? _tempEnd ?? _stringResources.hEnd))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: (_screenHeight * .132)),),
              Container(
                height: (_screenHeight * .3253).toDouble(),
                padding: EdgeInsets.symmetric(vertical: (_screenHeight * .029)),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  onTimerDurationChanged: (duration){
                    String hh = (duration.inMinutes / 60).truncate().toString();
                    String mm = (duration.inMinutes % 60).toString();
                    if(widget._isStart){
                      setState(() {
                        _tempStart = "$hh : $mm";
                      });
                    }
                    else {
                      setState(() {
                        _tempEnd = "$hh : $mm";
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: (_screenHeight * .0974)),
              ),
              _getSaveButton()
            ],
          ),
        ),
      ),
    );
  }


  Widget _getSaveButton(){
    return Center(
      child: Container(
        width: _confirmButtonWidth,
        height: _confirmButtonHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28.0))
        ),
        child: InkWell(
          onTap: (){
            _validate();
          },
          child: Center(
            child: Text(_stringResources.bSave.toUpperCase(),
              style: TextStyle(color: Colors.orange),),
          ),
        ),
      ),
    );
  }


  void _chooseEndTime(String startTime){
    setState(() {
      _tempStart = startTime;
    });
  }

  void _chooseStartTime(String endTime){
    setState(() {
      _tempEnd = endTime;
    });
  }
  void _validate(){
    Navigator.pop(context,{0: _tempStart, 1 : _tempEnd});
  }
}