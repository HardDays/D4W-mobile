import 'package:flutter/material.dart';

class Filter {
  String place;
  String startHour;
  String endHour;
  List<String> date;
  int numberOfPlaces;
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
      this.numberOfPlaces = 1,
      this.printerNeeded = false,
      this.teaOrCoffeeNeeded = false,
      this.conferenceRoomNeeded = false,
      this.kitchenNeeded = false,
      this.parkForBicycleNeeded = false});

  @override
  String toString() {
    return 'Filter{place: $place, startHour: $startHour, endHour: $endHour, '
        'date: $date, numberOfPlaces: $numberOfPlaces,'
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

  void updateFilterInfo(
      {String latLong,
      List<String> date,
      String startHour,
      String endHour,
      int numberOfPlaces,
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
          numberOfPlaces: numberOfPlaces ?? 1,
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
        filter.numberOfPlaces = numberOfPlaces ?? 1;
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
  }

  void clearFilter() {
    filter = null;
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
