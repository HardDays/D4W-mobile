import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filter {
  static const String FILTER_PLACE = "filterPlace";
  static const String FILTER_START_HOUR = "filterStartHour";
  static const String FILTER_END_HOUR = "filterEndHour";
  static const String FILTER_DATES = "filterDates";
  static const String FILTER_NUMBER_OF_SEATS_NEEDED =
      "filterNumberOfSeatsNeeded";
  static const String FILTER_PRINTER = "filterPrinter";
  static const String FILTER_CONFERENCE_ROOM = "filterCOnferenceRoom";
  static const String FILTER_KITCHEN = "filterKitchen";
  static const String FILTER_BIKE_STORAGE = "filterBikeStorage";
  static const String FILTER_TEA_COFFEE = "filterCoffeTea";
  static const String FILTER_IS_SET = 'isFilterSet';

  String place;
  String startHour;
  String endHour;
  List<String> date;
  int numberOfSeatsNeeded;
  bool printerNeeded;
  bool teaOrCoffeeNeeded;
  bool conferenceRoomNeeded;
  bool kitchenNeeded;
  bool parkForBicycleNeeded;

  Filter(
      {this.place,
      this.date,
      this.startHour,
      this.endHour,
      this.numberOfSeatsNeeded = 1,
      this.printerNeeded = false,
      this.teaOrCoffeeNeeded = false,
      this.conferenceRoomNeeded = false,
      this.kitchenNeeded = false,
      this.parkForBicycleNeeded = false});

  @override
  String toString() {
    return 'Filter{place: $place, startHour: $startHour, endHour: $endHour, '
        'date: $date, numberOfSeatsNeeded: $numberOfSeatsNeeded,'
        ' printerNeeded: $printerNeeded, teaOrCoffeeNeeded: $teaOrCoffeeNeeded,'
        ' conferenceRoomNeeded: $conferenceRoomNeeded, '
        'kitchenNeeded: $kitchenNeeded,'
        ' parkForBicycleNeeded: $parkForBicycleNeeded}';
  }
}

class FilterStateContainer extends StatefulWidget {
  final Widget child;
  final Filter filter;

  FilterStateContainer({@required this.child, this.filter});

  static FilterStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedFilterStateContainer)
            as _InheritedFilterStateContainer)
        .data;
  }

  @override
  State<StatefulWidget> createState() => FilterStateContainerState();
}

class FilterStateContainerState extends State<FilterStateContainer> {
  Filter filter;

  void getFilter() {
    SharedPreferences.getInstance().then((sp){
      bool isFilterSet = sp.getBool(Filter.FILTER_IS_SET);
      print('gettting filter preferences');
      if (isFilterSet != null && isFilterSet == true) {
        Filter filter = Filter();
        filter.place = sp.getString(Filter.FILTER_PLACE) ;
        filter.date = [];
        filter.date = sp.getStringList(Filter.FILTER_DATES);
        filter.endHour = sp.getString(Filter.FILTER_END_HOUR);
        filter.startHour = sp.getString(Filter.FILTER_START_HOUR);
        filter.parkForBicycleNeeded = sp.getBool(Filter.FILTER_BIKE_STORAGE)  ?? false;
        filter.teaOrCoffeeNeeded = sp.getBool(Filter.FILTER_TEA_COFFEE)  ?? false;
        filter.conferenceRoomNeeded = sp.getBool(Filter.FILTER_CONFERENCE_ROOM)  ?? false;
        filter.printerNeeded = sp.getBool(Filter.FILTER_PRINTER)  ?? false;
        filter.kitchenNeeded = sp.getBool(Filter.FILTER_KITCHEN)  ?? false;
        filter.numberOfSeatsNeeded =
            sp.getInt(Filter.FILTER_NUMBER_OF_SEATS_NEEDED) ?? 1;
        setState(() {
          this.filter = filter;
        });
      }
    });
  }

  void updateFilterInfo(
      {String latLong,
      List<String> date,
      String startHour,
      String endHour,
      int numberOfSeatsNeeded,
      bool printerNeeded,
      bool teaOrCoffeeNeeded,
      conferenceRoomNeeded,
      kitchenNeeded,
      parkForBicycleNeeded}) {
    if (filter == null) {
      filter = Filter(
          place: latLong,
          date: date,
          startHour: startHour,
          endHour: endHour,
          numberOfSeatsNeeded: numberOfSeatsNeeded ?? 1,
          printerNeeded: printerNeeded ?? false,
          teaOrCoffeeNeeded: teaOrCoffeeNeeded ?? false,
          conferenceRoomNeeded: conferenceRoomNeeded ?? false,
          kitchenNeeded: kitchenNeeded ?? false,
          parkForBicycleNeeded: parkForBicycleNeeded ?? false);

      setState(() {
        filter = filter;
      });
    } else {
      setState(() {
        filter.place = latLong ?? filter.place;
        filter.date = date ?? filter.date;
        filter.startHour = startHour ?? filter.startHour;
        filter.endHour = endHour ?? filter.endHour;
        filter.numberOfSeatsNeeded = numberOfSeatsNeeded ?? 1;
        filter.printerNeeded = printerNeeded ?? filter.printerNeeded;
        filter.teaOrCoffeeNeeded =
            teaOrCoffeeNeeded ?? filter.teaOrCoffeeNeeded;
        filter.conferenceRoomNeeded =
            conferenceRoomNeeded ?? filter.conferenceRoomNeeded;
        filter.kitchenNeeded = kitchenNeeded ?? filter.kitchenNeeded;
        filter.parkForBicycleNeeded =
            parkForBicycleNeeded ?? filter.parkForBicycleNeeded;
      });
    }
    SharedPreferences.getInstance().then((sp) {
      sp.setString(Filter.FILTER_PLACE, latLong ?? filter.place);
      sp.setStringList(Filter.FILTER_DATES, date ?? filter.date);
      sp.setString(Filter.FILTER_END_HOUR, endHour ?? filter.endHour);
      sp.setString(Filter.FILTER_START_HOUR, startHour ?? filter.startHour);
      sp.setBool(Filter.FILTER_BIKE_STORAGE, parkForBicycleNeeded ?? filter.parkForBicycleNeeded);
      sp.setBool(Filter.FILTER_TEA_COFFEE, teaOrCoffeeNeeded ?? filter.teaOrCoffeeNeeded);
      sp.setBool(Filter.FILTER_CONFERENCE_ROOM, conferenceRoomNeeded ?? filter.conferenceRoomNeeded);
      sp.setBool(Filter.FILTER_PRINTER, printerNeeded ?? filter.printerNeeded);
      sp.setBool(Filter.FILTER_KITCHEN, kitchenNeeded ?? filter.kitchenNeeded);
      sp.setInt(Filter.FILTER_NUMBER_OF_SEATS_NEEDED, numberOfSeatsNeeded ?? filter.numberOfSeatsNeeded);
      sp.setBool(Filter.FILTER_IS_SET, true);
    });
  }

  void clearFilter() {
    filter = null;
    SharedPreferences.getInstance().then((sp) {
      sp.remove(Filter.FILTER_PLACE);
      sp.remove(Filter.FILTER_DATES);
      sp.remove(Filter.FILTER_END_HOUR);
      sp.remove(Filter.FILTER_START_HOUR);
      sp.remove(Filter.FILTER_BIKE_STORAGE);
      sp.remove(Filter.FILTER_TEA_COFFEE);
      sp.remove(Filter.FILTER_CONFERENCE_ROOM);
      sp.remove(Filter.FILTER_PRINTER);
      sp.remove(Filter.FILTER_KITCHEN);
      sp.remove(Filter.FILTER_NUMBER_OF_SEATS_NEEDED);
      sp.setBool(Filter.FILTER_IS_SET, false);
    });
    setState(() {
      filter = Filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedFilterStateContainer(data: this, child: widget.child);
  }
}

class _InheritedFilterStateContainer extends InheritedWidget {
  final FilterStateContainerState data;

  _InheritedFilterStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
