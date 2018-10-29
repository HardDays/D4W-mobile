import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/calendar_util.dart' show CalendarCarousel;
import 'package:desk4work/view/common/theme_util.dart';
import 'package:flutter/material.dart';

class DateFilterScreen extends StatefulWidget {
  final List<DateTime> _selectedDate;
  final bool isMultiple;

  DateFilterScreen(this._selectedDate, {this.isMultiple = true});

  @override
  State<StatefulWidget> createState() => _DateFilterScreenState();
}

class _DateFilterScreenState extends State<DateFilterScreen> {
  Size _screenSize;
  double _screenHeight;
  double _screenWidth;
  StringResources _stringResources;
  double _confirmButtonHeight;
  double _confirmButtonWidth;
  List<DateTime> _selectedDate = [];

  @override
  void initState() {
    _selectedDate.addAll(widget._selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    print('screeen size: $_screenSize');
    final double confirmButtonHeight = (_screenHeight * .0824);
    final double confirmButtonWidth = (_screenWidth * .84);
    _stringResources = StringResources.of(context);
    _confirmButtonHeight = (_screenHeight * .0824);
    _confirmButtonWidth = (_screenWidth * .84);

    return Theme(
      data: ThemeUtil.getThemeForOrangeBackground(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecorationUtil.getDarkOrangeGradient(),
          child: Column(
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
              Center(
                child: Text(_stringResources.tDateExplanation),
              ),
              Container(
                  width: _screenWidth,
                  height: (_screenHeight * .5262),
                  child: _getCalendar()),
              Padding(
                padding: EdgeInsets.only(top: (_screenHeight * .1154)),
              ),
              Center(
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCalendar() {
    var daysOfTheWeek = <String>[
      _stringResources.tSunday,
      _stringResources.tMonday,
      _stringResources.tTuesday,
      _stringResources.tWednesday,
      _stringResources.tThursday,
      _stringResources.tFriday,
      _stringResources.tSaturday
    ];
    return CalendarCarousel(
      weekDays: daysOfTheWeek,
      onDayPressed: (DateTime date) {
        this.setState(() => _selectedDate =
            widget.isMultiple ? _addDate(_selectedDate, date) : [date]);
      },
      weekendTextStyle: TextStyle(
        color: Colors.white,
      ),
      thisMonthDayBorderColor: Colors.grey,
      height: (_screenHeight * .5262),
      selectedDateTime: _selectedDate,
      selectedDayTextStyle: TextStyle(color: Colors.orange),
      selectedDayButtonColor: Colors.white,
      selectedDayBorderColor: Colors.white,
      iconColor: Colors.white,
      headerTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
      weekdayTextStyle: TextStyle(color: Colors.white),
      prevDaysTextStyle: TextStyle(color: Colors.white.withOpacity(0.54)),
      daysTextStyle: TextStyle(
          color: Colors.white, letterSpacing: _screenWidth < 360.0 ? -3.0 : null),
      todayTextStyle: TextStyle(color: Colors.white),
      weekDayMargin:
          EdgeInsets.only(bottom: (_screenHeight * .0435).toDouble()),
    );
  }

  List<DateTime> _addDate(List<DateTime> oldList, DateTime newDate) {
    if (oldList.length < 1) {
      oldList.add(newDate);
      return oldList;
    } else {
      List<DateTime> newList = List();
      if (oldList.length == 1) {
        DateTime firstSelectedDate = oldList[0];
        if (oldList[0] != newDate)
          oldList.add(newDate);
        else
          return oldList;

        if (newDate.isBefore(firstSelectedDate)) swap(oldList, 0, 1);

        int dayDiff = newDate.difference(firstSelectedDate).inDays.abs();
        print("difff $dayDiff");
        if (dayDiff > 1) {
          DateTime start = oldList[0];
          newList.add(start);
          int count = 1;
          while ((dayDiff - count) > 0) {
            newList.add(start.add(Duration(days: count)));
            count++;
          }
          newList.add(oldList[oldList.length - 1]);
          return newList;
        } else
          return oldList;
      } else {
        newList.add(newDate);
        return newList;
      }
    }
  }

  void swap(List<DateTime> dateTime, int one, int two) {
    DateTime temp = dateTime[one];
    dateTime[one] = dateTime[two];
    dateTime[two] = temp;
  }

  _validate() {
    Navigator.pop(context, _selectedDate);
  }
}
