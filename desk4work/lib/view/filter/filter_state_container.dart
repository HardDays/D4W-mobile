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
  static const String FILTER_FREE_PRINTING = "filterFreePrinting";
  static const String FILTER_FREE_PARKING = "filterFreeParking";
  static const String FILTER_PARKING = "filterParking";
  static const String FILTER_KITCHEN = "filterKitchen";
  static const String FILTER_TEA_COFFEE = "filterCoffeTea";
  static const String FILTER_IS_SET = 'isFilterSet';

  String place;
  String startHour = FilterStateContainerState.getDefaultStartHour();
  String endHour = FilterStateContainerState.getDefaultEndHour();
  List<String> date;
  int numberOfSeatsNeeded;
  bool printerNeeded;
  bool teaOrCoffeeNeeded;
  bool kitchenNeeded;
  bool parkingNeeded;

  bool freeParkingNeeded;
  bool freePrinter;

  Filter(
      {this.place,
      this.date,
      this.startHour,
      this.endHour,
      this.numberOfSeatsNeeded = 1,
      this.printerNeeded = false,
      this.teaOrCoffeeNeeded = false,
      this.kitchenNeeded = false,
      this.parkingNeeded = false,
      this.freePrinter = false,
      this.freeParkingNeeded = false});

  static Future<Filter> savedFilter() {
    return SharedPreferences.getInstance().then((sp) {
      bool isFilterSet = sp.getBool(Filter.FILTER_IS_SET);
      print('gettting filter preferences');
      if (isFilterSet != null && isFilterSet == true) {
        Filter filter = Filter();
        filter.place = sp.getString(Filter.FILTER_PLACE);
        filter.date = [];
        filter.date = FilterStateContainerState.getDefaultDate();
        filter.endHour = FilterStateContainerState.getDefaultEndHour();
        filter.startHour = FilterStateContainerState.getDefaultStartHour();
        filter.parkingNeeded = sp.getBool(Filter.FILTER_PARKING) ?? false;
        filter.teaOrCoffeeNeeded =
            sp.getBool(Filter.FILTER_TEA_COFFEE) ?? false;
        filter.freePrinter = sp.getBool(Filter.FILTER_FREE_PRINTING) ?? false;
        filter.freeParkingNeeded =
            sp.getBool(Filter.FILTER_FREE_PARKING) ?? false;

        filter.printerNeeded = sp.getBool(Filter.FILTER_PRINTER) ?? false;
        filter.kitchenNeeded = sp.getBool(Filter.FILTER_KITCHEN) ?? false;
        filter.numberOfSeatsNeeded =
            sp.getInt(Filter.FILTER_NUMBER_OF_SEATS_NEEDED) ?? 1;
        return filter;
      } else
        return Future.value(null);
    });
  }

  @override
  String toString() {
    return 'Filter{place: $place, startHour: $startHour, endHour: $endHour, '
        'date: $date, numberOfSeatsNeeded: $numberOfSeatsNeeded,'
        ' printerNeeded: $printerNeeded, teaOrCoffeeNeeded: $teaOrCoffeeNeeded,'
        ' parkingNeeded: $parkingNeeded, '
        'freeparkingNeede: $freeParkingNeeded'
        'freePrintingNeeded: $freePrinter'
        'kitchenNeeded: $kitchenNeeded,'
        ' parkForBicycleNeeded: $parkingNeeded}';
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
    SharedPreferences.getInstance().then((sp) {
      bool isFilterSet = sp.getBool(Filter.FILTER_IS_SET);
      print('gettting filter preferences');
      if (isFilterSet != null && isFilterSet == true) {
        Filter filter = Filter();
        filter.place = sp.getString(Filter.FILTER_PLACE);
        filter.date = [];
        filter.date = getDefaultDate();
        filter.endHour = getDefaultEndHour();
        filter.startHour = getDefaultStartHour();
        filter.parkingNeeded = sp.getBool(Filter.FILTER_PARKING) ?? false;
        filter.teaOrCoffeeNeeded =
            sp.getBool(Filter.FILTER_TEA_COFFEE) ?? false;
        filter.freePrinter = sp.getBool(Filter.FILTER_FREE_PRINTING) ?? false;
        filter.freeParkingNeeded =
            sp.getBool(Filter.FILTER_FREE_PARKING) ?? false;
        filter.printerNeeded = sp.getBool(Filter.FILTER_PRINTER) ?? false;
        filter.kitchenNeeded = sp.getBool(Filter.FILTER_KITCHEN) ?? false;
        filter.numberOfSeatsNeeded =
            sp.getInt(Filter.FILTER_NUMBER_OF_SEATS_NEEDED) ?? 1;
        setState(() {
          this.filter = filter;
        });
      } else {
        Filter filter = Filter();
        filter.endHour = getDefaultEndHour();
        filter.startHour = getDefaultStartHour();
        setState(() {
          this.filter = filter;
        });
      }
    });
  }

  static String getDefaultStartHour() {
    print('start minuests: ${getMinutes()}');
    int minutesToAdd = getMinutes() + 15;
    Duration duration  = Duration(minutes: minutesToAdd);
    DateTime now = DateTime.now().add(duration);
    int intHour = now.hour;
    intHour = intHour % 24;
    String hour = (intHour > 9) ? intHour.toString() : '0$intHour';
    int intMinutes = minutesToAdd % 60;
    String minutes = (intMinutes > 9) ? intMinutes.toString() : '0$intMinutes';
    return '$hour:$minutes';
  }

  static String getDefaultEndHour() {
    int minutesToAdd = getMinutes() + 15;
    Duration duration  = Duration(hours:2, minutes: minutesToAdd);
    DateTime now = DateTime.now().add(duration);
    int intHour = now.hour;
    intHour = intHour % 24;
    String hour = (intHour > 9) ? intHour.toString() : '0$intHour';
    int intMinutes = minutesToAdd % 60;
    String minutes = (intMinutes > 9) ? intMinutes.toString() : '0$intMinutes';
    return '$hour:$minutes';
  }



  static int getMinutes(){
    int currentMinutes = DateTime.now().minute;
    int closestQuarter = currentMinutes % 15;
    if(currentMinutes <=15){
      return 15;
    }
    return (currentMinutes + (15 - closestQuarter));

  }



  void updateFilterInfo(
      {String latLong,
      List<String> date,
      String startHour,
      String endHour,
      int numberOfSeatsNeeded,
      bool printerNeeded,
      bool teaOrCoffeeNeeded,
      parkingNeeded,
      kitchenNeeded,
      freeParkingNeeded,
      freePrinterNeeded}) {
    if (filter == null) {
      filter = Filter(
          place: latLong,
          date: date,
          startHour: startHour,
          endHour: endHour,
          numberOfSeatsNeeded: numberOfSeatsNeeded ?? 1,
          printerNeeded: printerNeeded ?? false,
          teaOrCoffeeNeeded: teaOrCoffeeNeeded ?? false,
          parkingNeeded: parkingNeeded ?? false,
          kitchenNeeded: kitchenNeeded ?? false,
          freeParkingNeeded: freeParkingNeeded ?? false,
          freePrinter: freePrinterNeeded ?? false);

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
        filter.parkingNeeded = parkingNeeded ?? filter.parkingNeeded;
        filter.kitchenNeeded = kitchenNeeded ?? filter.kitchenNeeded;
        filter.freeParkingNeeded =
            freeParkingNeeded ?? filter.freeParkingNeeded;
        filter.freePrinter = freePrinterNeeded ?? filter.freePrinter;
      });
    }
    SharedPreferences.getInstance().then((sp) {
      sp.setString(Filter.FILTER_PLACE, latLong ?? filter.place);
//      sp.setStringList(Filter.FILTER_DATES, date ?? filter.date);
//      sp.setString(Filter.FILTER_END_HOUR, endHour ?? filter.endHour);
//      sp.setString(Filter.FILTER_START_HOUR, startHour ?? filter.startHour);
      sp.setBool(Filter.FILTER_PARKING, parkingNeeded ?? filter.parkingNeeded);
      sp.setBool(Filter.FILTER_TEA_COFFEE,
          teaOrCoffeeNeeded ?? filter.teaOrCoffeeNeeded);
      sp.setBool(Filter.FILTER_FREE_PARKING,
          freeParkingNeeded ?? filter.freeParkingNeeded);
      sp.setBool(
          Filter.FILTER_FREE_PRINTING, freePrinterNeeded ?? filter.freePrinter);
      sp.setBool(Filter.FILTER_PRINTER, printerNeeded ?? filter.printerNeeded);
      sp.setBool(Filter.FILTER_KITCHEN, kitchenNeeded ?? filter.kitchenNeeded);
      sp.setInt(Filter.FILTER_NUMBER_OF_SEATS_NEEDED,
          numberOfSeatsNeeded ?? filter.numberOfSeatsNeeded);
      sp.setBool(Filter.FILTER_IS_SET, true);
    });
  }




  static List<String> getDefaultDate() {
    DateTime dateTime = DateTime.now();
    int dayInt = dateTime.day;
    String day = (dayInt < 10) ? "0$dayInt" : dayInt.toString();
    int montInt = dateTime.month;
    String month = (montInt < 10) ? "0$montInt" : montInt.toString();
    String year = dateTime.year.toString();
    return <String>["$day.$month.$year"];
  }

  void clearFilter() {
    filter = null;
    SharedPreferences.getInstance().then((sp) {
      sp.remove(Filter.FILTER_PLACE);
//      sp.remove(Filter.FILTER_DATES);
//      sp.remove(Filter.FILTER_END_HOUR);
//      sp.remove(Filter.FILTER_START_HOUR);
      sp.remove(Filter.FILTER_PARKING);
      sp.remove(Filter.FILTER_TEA_COFFEE);
      sp.remove(Filter.FILTER_FREE_PRINTING);
      sp.remove(Filter.FILTER_FREE_PARKING);
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
