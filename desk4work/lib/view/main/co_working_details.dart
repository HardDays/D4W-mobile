import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/dots_indicator.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';

class CoWorkingDetailsScreen extends StatefulWidget {
  final CoWorking _coWorking;

  CoWorkingDetailsScreen(this._coWorking);

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

  _CoWorkingDetailsScreenState();

  bool _isPrinterSelected = false,
      _isCoffeeSelected = false,
      _isConferenceRoomSelected = false,
      _isBikeStorageSelected = false,
      _isKitchenSelected = false;
  String _explanations;

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;

    return SafeArea(
      child: Scaffold(
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
                Icons.place,
                color: Colors.white,
              ),
              onPressed: _showOnMap(),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
                height: (_screenHeight * .3238), child: _buildImagesSlide()),
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
                      padding: EdgeInsets.symmetric(
                          vertical: _screenHeight * .0105)),
                  Text(
                    widget._coWorking.description,
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
                      padding: EdgeInsets.symmetric(
                          vertical: _screenHeight * .0105)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _stringResources.tFreePlaces,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(widget._coWorking.capacity.toString()),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: _screenHeight * .009)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_stringResources.tRemainingTime,
                          style: Theme.of(context).textTheme.caption),
                      Text(widget._coWorking.capacity.toString()),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: _screenHeight * .009)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_stringResources.tGuests,
                          style: Theme.of(context).textTheme.caption),
                      Text(widget._coWorking.capacity.toString()),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: (_screenHeight * .276),
            ),
            Container(
              height: (_screenHeight * .0618),
              padding: EdgeInsets.symmetric(
                  vertical: _screenHeight * .015,
                  horizontal: _screenWidth * .0413),
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      bottom: BorderSide(color: Colors.black26, width: .5))),
              child: InkWell(
                onTap: _showOnMap(),
                child: Row(
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
                  _stringResources.bBook,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: _getOrangeBoxDecoration(1),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stringResources.tMonday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(1)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                    Container(
                      decoration: _getOrangeBoxDecoration(5),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stringResources.tFriday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(5)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: _getOrangeBoxDecoration(2),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stringResources.tTuesday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(2)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                    Container(
                      decoration: _getOrangeBoxDecoration(6),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            _stringResources.tSaturday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(6)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: _getOrangeBoxDecoration(3),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _stringResources.tWednesday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(3)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                    Container(
                      decoration: _getOrangeBoxDecoration(7),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stringResources.tSunday.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: _getTextColor(7)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: _getOrangeBoxDecoration(4),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stringResources.tThursday.toUpperCase(),
                            style: TextStyle(color: _getTextColor(4)),
                          ),
                          _getWorkgingHours(ConstantsManager.MONDAY),
                        ],
                      ),
                    ),
                    Container(
                      decoration: _getOrangeBoxDecoration(4),
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "mmmmmmm",
                            style: TextStyle(color: _getTextColor(4)),
                          ),
                          Text("mmmm")
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getAmenitiesContainer() {
    return Container(
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
              children: _getAmenitiesWidget(_getAmenities())),
          Padding(
              padding: EdgeInsets.only(
            bottom: _screenHeight * .015,
          )),
          Text(
            _explanations ?? "",
            style: Theme.of(context).textTheme.caption,
          ),
          Padding(
              padding: EdgeInsets.only(
            bottom: _screenHeight * .03,
          ))
        ],
      ),
    );
  }

  Text _getWorkgingHours(String day){
    String start = "//://";
    String end = "//://";
    widget._coWorking.workingDays.forEach((workingDay){
      if(workingDay.day == day){
        start = workingDay.beginWork;
        end = workingDay.endWork;
      }
    });
    return Text(start + " - "+ end);
  }

  Widget _getContactContainer() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _screenHeight * .03,
        horizontal: _screenWidth * .0413,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _stringResources.tContacts,
            style: Theme.of(context).textTheme.subhead,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: _screenHeight * .009)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Image.asset(
                  'assets/phone_green.png',
                  height: _screenHeight * .072,
                  width: _screenWidth * .128,
                ),
                onTap: _openPhone,
              ),
              InkWell(
                child: Image.asset(
                  'assets/vk_color.png',
                  height: _screenHeight * .072,
                  width: _screenWidth * .128,
                ),
                onTap: _openVk,
              ),
              InkWell(
                child: Image.asset(
                  'assets/fb_color.png',
                  height: _screenHeight * .072,
                  width: _screenWidth * .128,
                ),
                onTap: _openFacebook,
              ),
              InkWell(
                child: Image.asset(
                  'assets/insta_color.png',
                  height: _screenHeight * .072,
                  width: _screenWidth * .128,
                ),
                onTap: _openInsta,
              ),
              InkWell(
                child: Image.asset(
                  'assets/twitter_color.png',
                  height: _screenHeight * .072,
                  width: _screenWidth * .128,
                ),
                onTap: _openTwitter,
              ),
            ],
          )
        ],
      ),
    );
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
            String message = _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipPrinter}";
            Widget printerIconButton = _getEquipmentButton(Icons.print,
                _stringResources.tPrint, _isPrinterSelected, message, 1);
            amenitiesWidgets.add(printerIconButton);
            break;
          case COFFEE_OR_TEA:
            String message = _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipTeaCoffee}";
            Widget coffeeIconButton = _getEquipmentButton(Icons.local_cafe,
                _stringResources.tTeaOrCoffee, _isCoffeeSelected, message, 2);
            amenitiesWidgets.add(coffeeIconButton);
            break;
          case PRINTER:
            String message = _getMessageStart(amenities[amenity]) +
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
            String message = _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipBikeStorage}";
            Widget bikeIconButton = _getEquipmentButton(
                Icons.print,
                _stringResources.tParkForBicycle,
                _isPrinterSelected,
                message,
                4);
            amenitiesWidgets.add(bikeIconButton);
            break;
          case PRINTER:
            String message = _getMessageStart(amenities[amenity]) +
                " ${_stringResources.tipKitchen}";
            IconButton kitchenIconButton = IconButton(
              onPressed: () => _setTipText(message),
              icon: Icon(Icons.local_dining),
            );
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
                  _switchButton(buttonToSwitch);
                  _setTipText(explain);
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
          _isPrinterSelected = !_isPrinterSelected;
        });
        break;
      case 2:
        setState(() {
          _isCoffeeSelected = !_isCoffeeSelected;
        });
        break;
      case 3:
        setState(() {
          _isConferenceRoomSelected = !_isConferenceRoomSelected;
        });
        break;
      case 4:
        setState(() {
          _isBikeStorageSelected = !_isBikeStorageSelected;
        });
        break;
      case 5:
        setState(() {
          _isKitchenSelected = !_isKitchenSelected;
        });
    }
  }

  _bookPlace() {}

  _showOnMap() {}

  Widget _buildImagesSlide() {
    return Stack(
      children: <Widget>[
        PageView.builder(
          itemBuilder: (context, index) {
            return _getImageForHeader(widget._coWorking.images[index], index);
          },
          itemCount: widget._coWorking.images.length,
          physics: AlwaysScrollableScrollPhysics(),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            color: Colors.grey[800].withOpacity(0.5),
            padding: const EdgeInsets.all(20.0),
            child: new Center(
              child: new DotsIndicator(
                controller: _controller,
                itemCount: widget._coWorking.images.length,
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

  Widget _getImageForHeader(String url, int index) {
    return Hero(
        tag: url + index.toString(),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          placeholder: CircularProgressIndicator(),
          height: (_screenHeight * .3238),
          errorWidget: Icon(
            Icons.error,
            size: (_screenHeight * .3238),
          ),
          imageUrl: "",
        ));
  }

  BoxDecoration _getOrangeBoxDecoration(int dayOfTheWeek) {
    return (DateTime.now().day == dayOfTheWeek)
        ? BoxDecorationUtil.getOrangeRoundedCornerBoxDecoration()
        : null;
  }

  Color _getTextColor(int dayOfTheWeek) {
    return (DateTime.now().day == dayOfTheWeek) ? Colors.black : Colors.black;
  }
}
