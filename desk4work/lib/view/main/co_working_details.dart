import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/dots_indicator.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/main/new_booking.dart';
import 'package:desk4work/view/main/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class CoWorkingDetailsScreen extends StatefulWidget {
  final CoWorking _coWorking;
  final String _token;

  CoWorkingDetailsScreen(this._coWorking, this._token);

  @override
  State<StatefulWidget> createState() => _CoWorkingDetailsScreenState();
}

class _CoWorkingDetailsScreenState extends State<CoWorkingDetailsScreen> {
  StringResources _stringResources;
  Size _screenSize;
  double _screenHeight, _screenWidth;

  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  bool _hasFreeSeats, _hasLocation;

  _CoWorkingDetailsScreenState();

  bool _isPrinterSelected = false,
      _isCoffeeSelected = false,
      _isConferenceRoomSelected = false,
      _isBikeStorageSelected = false,
      _isKitchenSelected = false;
  String _token;
  String _explanations;
  MapController _mapController;
  CoWorkingApi _coWorkingApi;

  bool _showOnMap;

  @override
  void initState() {
    _showOnMap = false;
    _mapController = MapController();
    _coWorkingApi = CoWorkingApi();
    _hasFreeSeats = true;
    _hasLocation =
        (widget._coWorking.lat != null && widget._coWorking.lng != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    _token = widget._token; // global

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          _stringResources.tPlace,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                _showOnMap ? Icons.details : Icons.place,
                color: Colors.white,
              ),
              onPressed: () {
                if (_hasLocation) {
                  setState(() {
                    _showOnMap = !_showOnMap;
                  });
                }
              })
        ],
      ),
      body: _showOnMap ? _showMap() : _showDetails(),
    );
  }

  Widget _showDetails() {
    return Container(
      height: _screenHeight,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              height: (_screenHeight * .3238),
              child: (widget._coWorking.images != null)
                  ? _buildImagesSlide()
                  : Container(
                      child: Image.asset('assets/placeholder.png'),
                    )),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: _screenHeight * .03,
              horizontal: _screenWidth * .0413,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget._coWorking.fullName,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: _screenHeight * .0105)),
                Text(
                  widget._coWorking.description ?? '',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black26,
            height: .5,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: _screenHeight * .03,
              horizontal: _screenWidth * .0413,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _stringResources.tMainInfo,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: _screenHeight * .0105)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _stringResources.tFreePlaces,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    _buildFreeSeats(widget._coWorking.id)
                  ],
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: _screenHeight * .009)),
              ],
            ),
          ),
          (_hasLocation)
              ? Container(
                  height: (_screenHeight * .276),
                  child: _buildMap(),
                )
              : Container(),
          Container(
            height: (_screenHeight * .0618),
            padding: EdgeInsets.symmetric(
                vertical: _screenHeight * .015,
                horizontal: _screenWidth * .0413),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(color: Colors.black26, width: .5))),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showOnMap = true;
                });
              },
              child: widget._coWorking.address == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          color: Colors.orange,
                        ),
                        Text(widget._coWorking.address ?? " ",
                            style: Theme.of(context).textTheme.caption)
                      ],
                    ),
            ),
          ),
          _getWorkingHours(),
          _getAmenitiesContainer(),
          _getContactContainer(),
          Container(
            height: _screenHeight * .0825,
            margin: EdgeInsets.symmetric(
              vertical: _screenHeight * .081,
              horizontal: _screenWidth * .0413,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                gradient: BoxDecorationUtil.getOrangeGradient().gradient,
                borderRadius: BorderRadius.all(Radius.circular(28.0))),
            child: InkWell(
              onTap: _bookPlace,
              child: Center(
                  child: Text(
                _hasFreeSeats
                    ? _stringResources.bBook
                    : _stringResources.tNoSeat,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMap() {
    String _mapBoxUrl =
        "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}";
    String _mapBoxToken =
        "pk.eyJ1Ijoidm92YW4xMjMiLCJhIjoiY2o3aXNicTFhMW9jbDJxbWw3bHNqMW92MCJ9.N1hCLnBrJjdX0JmYuA8bOw";
    String _mapBoxId = "mapbox.streets";
    double lat = widget._coWorking.lat;
    double lng = widget._coWorking.lng;
    LatLng mapCenter;
    if (_hasLocation)
      mapCenter = LatLng(lat, lng);
    else
      return Container();
    try {
      return Stack(
        children: <Widget>[
          mapCenter != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: LatLng(lat, lng),
                        zoom: 15.0,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate: _mapBoxUrl,
                          additionalOptions: {
                            'accessToken': _mapBoxToken,
                            'id': _mapBoxId,
                          },
                        ),
                        MarkerLayerOptions(markers: <Marker>[
                          Marker(
                              point: LatLng(lat, lng),
                              builder: (ctx) {
                                return Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image:
                                          AssetImage('assets/pin_orange.png'),
                                    ),
                                  ),
                                );
                              })
                        ])
                      ]),
                )
              : Container()
        ],
      );
    } catch (e) {
      print('building map in working details $e');
      return Container();
    }
  }

  Widget _getWorkingHours() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _screenHeight * .03,
        horizontal: _screenWidth * .0413,
      ),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: Colors.black26, width: .5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _stringResources.tWorkingHours,
            style: Theme.of(context).textTheme.subhead,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: _screenHeight * .03,
            ),
          ),
          Center(
            child: Container(
              width: _screenWidth * .7387,
              height: _screenHeight * .15,
              child: GridView.count(
                childAspectRatio: 4.0833,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: List.generate(
                    widget._coWorking.workingDays.length ?? 0, (index) {
                  return Container(
                      child: _getWorkgingHours(
                          widget._coWorking.workingDays[index]));
                }, growable: false),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: _screenHeight * .03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAmenitiesContainer() {
    Map<String, bool> amenities = _getAmenities();
    return amenities.length < 1
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(
              horizontal: _screenWidth * .0413,
            ),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(color: Colors.black26, width: .5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Title(
                    color: Colors.black,
                    child: Text(
                      _stringResources.tComfort,
                      style: Theme.of(context).textTheme.subhead,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _getAmenitiesWidget(amenities)),
                Padding(
                    padding: EdgeInsets.only(
                  bottom: _screenHeight * .015,
                )),
                Container(
                  height: _screenHeight * .054,
                  child: Text(
                    _explanations ?? " ",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                  bottom: _screenHeight * .03,
                ))
              ],
            ),
          );
  }

  Widget _getWorkgingHours(WorkingDays workingDay) {
    String start = workingDay.beginWork;
    String end = workingDay.endWork;
    String day;
    Color dayTextColor;
    Color timeTextColor;
    int weekDay;

    switch (workingDay.day) {
      case ConstantsManager.MONDAY:
        day = _stringResources.tMonday;
        dayTextColor = _getTextColor(1);
        timeTextColor = _getTextColor(1, defaultColor: Colors.black);
        weekDay = 1;
        break;

      case ConstantsManager.TUESDAY:
        day = _stringResources.tTuesday;
        dayTextColor = _getTextColor(2);
        timeTextColor = _getTextColor(2, defaultColor: Colors.black);
        weekDay = 2;
        break;

      case ConstantsManager.WEDNESDAY:
        day = _stringResources.tWednesday;
        dayTextColor = _getTextColor(3);
        timeTextColor = _getTextColor(3, defaultColor: Colors.black);
        weekDay = 3;
        break;

      case ConstantsManager.THURSDAY:
        day = _stringResources.tThursday;
        dayTextColor = _getTextColor(4);
        timeTextColor = _getTextColor(4, defaultColor: Colors.black);
        weekDay = 4;
        break;

      case ConstantsManager.FRIDAY:
        day = _stringResources.tFriday;
        dayTextColor = _getTextColor(5);
        timeTextColor = _getTextColor(5, defaultColor: Colors.black);
        weekDay = 5;
        break;

      case ConstantsManager.SATURDAY:
        day = _stringResources.tSaturday;
        dayTextColor = _getTextColor(6);
        timeTextColor = _getTextColor(6, defaultColor: Colors.black);
        weekDay = 6;
        break;

      case ConstantsManager.SUNDAY:
        day = _stringResources.tSunday;
        dayTextColor = _getTextColor(7);
        timeTextColor = _getTextColor(7, defaultColor: Colors.black);
        weekDay = 7;
        break;
    }
    TextStyle textStyle = Theme.of(context).textTheme.caption;
    Text dayText = Text(
      day,
      style: textStyle.copyWith(color: dayTextColor),
    );
    Text hoursText = Text(
      "$start-$end",
      style: textStyle.copyWith(color: timeTextColor),
    );
    bool isToday = DateTime.now().day == weekDay;
    return Container(
      width: _screenWidth * .3653,
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: (isToday)
          ? BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(36.0)))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[dayText, hoursText],
      ),
    );
  }

  Widget _getContactContainer() {
    return Container();
//    return Container(
//      margin: EdgeInsets.symmetric(
//        vertical: _screenHeight * .03,
//        horizontal: _screenWidth * .0413,
//      ),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//            _stringResources.tContacts,
//            style: Theme.of(context).textTheme.subhead,
//          ),
//          Padding(
//              padding: EdgeInsets.symmetric(vertical: _screenHeight * .009)),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              InkWell(
//                child: Image.asset(
//                  'assets/phone_green.png',
//                  height: _screenHeight * .072,
//                  width: _screenWidth * .128,
//                ),
//                onTap: _openPhone,
//              ),
//              InkWell(
//                child: Image.asset(
//                  'assets/vk_color.png',
//                  height: _screenHeight * .072,
//                  width: _screenWidth * .128,
//                ),
//                onTap: _openVk,
//              ),
//              InkWell(
//                child: Image.asset(
//                  'assets/fb_color.png',
//                  height: _screenHeight * .072,
//                  width: _screenWidth * .128,
//                ),
//                onTap: _openFacebook,
//              ),
//              InkWell(
//                child: Image.asset(
//                  'assets/insta_color.png',
//                  height: _screenHeight * .072,
//                  width: _screenWidth * .128,
//                ),
//                onTap: _openInsta,
//              ),
//              InkWell(
//                child: Image.asset(
//                  'assets/twitter_color.png',
//                  height: _screenHeight * .072,
//                  width: _screenWidth * .128,
//                ),
//                onTap: _openTwitter,
//              ),
//            ],
//          )
//        ],
//      ),
//    );
  }

  CoWorkingPlaceMapScreen _showMap() {
    double lat = widget._coWorking.lat;
    double long = widget._coWorking.lng;
    if (_hasLocation) {
      LatLng defaultLocation = LatLng(lat, long);
      return CoWorkingPlaceMapScreen([widget._coWorking],
          defaultPosition: defaultLocation);
    }
  }

  _openPhone() {}

  _openVk() {}

  _openFacebook() {}

  _openInsta() {}

  _openTwitter() {}

  static const String PRINTER = "printer",
      COFFEE_OR_TEA = "coffeOrTea",
      CONFERENCE_ROOM = "conferenceRoom",
      BIKE_STORAGE = 'bikeStorage',
      KITCHEN = "kitchen";

  Map<String, bool> _getAmenities() {
    Map<String, bool> amenities = {};
    widget._coWorking.amenties.forEach((amenity) {
      switch (amenity) {
        case "free_printing":
          amenities[PRINTER] = true;
          break;
        case "printing":
          amenities[PRINTER] = false;
          break;
        case "free_coffee":
          amenities[COFFEE_OR_TEA] = true;
          break;
        case "coffee":
          amenities[COFFEE_OR_TEA] = false;
          break;
        case "free_conference_room":
          amenities[CONFERENCE_ROOM] = true;
          break;
        case "conference_room":
          amenities[CONFERENCE_ROOM] = false;
          break;
        case "free_bike_storage":
          amenities[BIKE_STORAGE] = true;
          break;
        case "bike_storage":
          amenities[BIKE_STORAGE] = false;
          break;
        case "free_kitchen":
          amenities[KITCHEN] = true;
          break;
        case "kitchen":
          amenities[KITCHEN] = false;
          break;
      }
    });
    return amenities;
  }

  List<Widget> _getAmenitiesWidget(Map<String, bool> amenities) {
    List<Widget> amenitiesWidgets = [];

    if (amenities != null && amenities.length > 1) {
      amenities.keys.forEach((amenity) {
        switch (amenity) {
          case PRINTER:
            String message =_isPrinterSelected ? " " : _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipPrinter}";
            Widget printerIconButton = _getEquipmentButton(Icons.print,
                _stringResources.tPrint, _isPrinterSelected, message, 1);
            amenitiesWidgets.add(printerIconButton);
            break;
          case COFFEE_OR_TEA:
            String message =_isCoffeeSelected ? " " : _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipTeaCoffee}";
            Widget coffeeIconButton = _getEquipmentButton(Icons.local_cafe,
                _stringResources.tTeaOrCoffee, _isCoffeeSelected, message, 2);
            amenitiesWidgets.add(coffeeIconButton);
            break;
          case PRINTER:
            String message = _isPrinterSelected ? " " :_getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipConferenceRoom}";
            Widget peopleIconButton = _getEquipmentButton(
                Icons.people,
                _stringResources.tConferenceRoom,
                _isPrinterSelected,
                message,
                3);
            amenitiesWidgets.add(peopleIconButton);
            break;
          case PRINTER:
            String message =_isPrinterSelected ? " " : _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipBikeStorage}";
            Widget bikeIconButton =  _getEquipmentButton(
                Icons.print,
                _stringResources.tParkForBicycle,
                _isPrinterSelected,
                message,
                4);
            amenitiesWidgets.add(bikeIconButton);
            break;
          case PRINTER:
            String message = _isKitchenSelected ? " " :_getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipKitchen}";
            Widget kitchenIconButton = _getEquipmentButton(Icons.local_dining,
                _stringResources.tKitchen, _isKitchenSelected, message, 5);
//            IconButton(
//              onPressed: () => _setTipText(message),
//              icon: Icon(Icons.local_dining),
//            );
            amenitiesWidgets.add(kitchenIconButton);
            break;
        }
      });
    } else {
      amenitiesWidgets.add(Container());
    }
    return amenitiesWidgets;
  }

  String _getMessageStart(bool isFreeEquipment) {
    return (isFreeEquipment)
        ? _stringResources.tFreeEquipment
        : _stringResources.tPaidEquipment;
  }

  void _setTipText(String message) {
    setState(() {
      _explanations = message;
    });
  }

  Column _getEquipmentButton(IconData icon, String caption, bool isSelected,
      String explain, int buttonToSwitch) {
    return Column(
      children: <Widget>[
        Container(
            height: _screenHeight * .072,
            width: _screenWidth * .128,
            decoration: (isSelected)
                ? BoxDecoration(color: Colors.orange, shape: BoxShape.circle)
                : null,
            child: IconButton(
                onPressed: () {
                  _setTipText(explain);
                  _switchButton(buttonToSwitch);
                },
                icon: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.black26,
                ))),
        Text(
          caption,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }

  _switchButton(int i) {
    print("switching $i");
    switch (i) {
      case 1:
        setState(() {
          _isConferenceRoomSelected = false;
          _isBikeStorageSelected = false;
          _isKitchenSelected = false;
          _isCoffeeSelected = false;
          _isPrinterSelected = !_isPrinterSelected;
        });
        break;
      case 2:
        setState(() {
          _isConferenceRoomSelected = false;
          _isBikeStorageSelected = false;
          _isKitchenSelected = false;
          _isPrinterSelected = false;
          _isCoffeeSelected = !_isCoffeeSelected;
        });
        break;
      case 3:
        setState(() {
          _isBikeStorageSelected = false;
          _isKitchenSelected = false;
          _isCoffeeSelected = false;
          _isPrinterSelected = false;
          _isConferenceRoomSelected = !_isConferenceRoomSelected;
        });
        break;
      case 4:
        setState(() {
          _isConferenceRoomSelected = false;
          _isKitchenSelected = false;
          _isCoffeeSelected = false;
          _isPrinterSelected = false;
          _isBikeStorageSelected = !_isBikeStorageSelected;
        });
        break;
      case 5:
        setState(() {
          _isConferenceRoomSelected = false;
          _isBikeStorageSelected = false;
          _isCoffeeSelected = false;
          _isPrinterSelected = false;
          _isKitchenSelected = !_isKitchenSelected;
        });
    }
  }

  _bookPlace() {
    if (widget._coWorking.freeSeats != null &&
        widget._coWorking.freeSeats > 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => NewBookingScreen(widget._coWorking)));
    } else {
      setState(() {
        _hasFreeSeats = false;
      });
    }
  }

//  _showOnMap() {
//    List<CoWorking> coWorkings = [];
//    coWorkings.add(widget._coWorking);
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (ctx) => CoWorkingPlaceMapScreen(coWorkings)));
//  }

  Widget _buildImagesSlide() {
    return Stack(
      children: <Widget>[
        PageView.builder(
          itemBuilder: (context, index) {
            return _getImageForHeader(widget._coWorking.images, index);
          },
          itemCount: widget._coWorking.images?.length ?? 0,
          controller: _controller,
          physics: AlwaysScrollableScrollPhysics(),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            color: Colors.grey[800].withOpacity(0.5),
            padding: const EdgeInsets.all(8.0),
            child: new Center(
              child: new DotsIndicator(
                controller: _controller,
                itemCount: widget._coWorking.images?.length ?? 0,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: _kDuration,
                    curve: _kCurve,
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getImageForHeader(List<int> images, int index) {
    return Hero(
        tag: "cowinkingdetails" + images[index].toString(),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          placeholder: CircularProgressIndicator(),
          height: (_screenHeight * .3238),
          errorWidget: Icon(
            Icons.error,
            size: (_screenHeight * .3238),
          ),
          imageUrl:
              ConstantsManager.BASE_URL + "images/get_full/${images[index]}",
        ));
  }

  FutureBuilder<int> _buildFreeSeats(int id) {
    return FutureBuilder<int>(
      future: _getFreeSeats(id),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return showMessage(_stringResources.mNoInternet);
          case ConnectionState.waiting:
            return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50.0),
                child: new CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              print("error  loading bookings ${snapshot.error}");
              return showMessage(_stringResources.mServerError);
            } else {
              print(' freeseat1: ${snapshot.data}');
              if (snapshot.data == null)
                return Container();
              else {
                int seats = snapshot.data;

                widget._coWorking.freeSeats = seats;

                return Text(seats.toString());
              }
            }
            break;
          case ConnectionState.active:
            break;
        }
      },
    );
  }

  Future<int> _getFreeSeats(int id) {
    return _coWorkingApi.getFreeSeat(_token, id);
  }

  BoxDecoration _getOrangeBoxDecoration(int dayOfTheWeek) {
    return (DateTime.now().day == dayOfTheWeek)
        ? BoxDecorationUtil.getOrangeRoundedCornerBoxDecoration()
        : null;
  }

  Color _getTextColor(int dayOfTheWeek, {Color defaultColor = Colors.grey}) {
    return (DateTime.now().day == dayOfTheWeek) ? Colors.white : defaultColor;
  }

  Widget showMessage(String message) {
    return Center(
      child: Text(message),
    );
  }
}
