import 'dart:async';

import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/api/image_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/filter/filter_root.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/place_filter.dart';
import 'package:desk4work/view/main/co_working_details.dart';
import 'package:desk4work/view/main/place_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoWorkingPlaceListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoWorkingPlaceListScreenState();
}

class _CoWorkingPlaceListScreenState extends State<CoWorkingPlaceListScreen> {
  List<CoWorking> _coWorkings = [];
  Set<int> coWorkingIds = Set();
  CoWorkingApi _coWorkingApi = CoWorkingApi();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources stringResources;
  Size _screenSize;
  Geolocator _geolocator;
  LatLng _userLocation;
  Map<String, LatLng> _cities;
  double _screenHeight, _screenWidth;
  ImageApi _imageApi;
  String _token;
  Filter _filter;
  bool _showAsList, _isLoading;
  bool _shouldLoadMore;
  bool _locationError;

  @override
  void initState() {
    _showAsList = false;
    _locationError = false;
    _isLoading = true;
    _shouldLoadMore = true;
    _cities = {
      PlaceFilterScreen.SAINT_PETERSBURG: LatLng(59.93863, 30.31413),
      PlaceFilterScreen.MOSCOW: LatLng(55.75222, 37.61556),
      PlaceFilterScreen.KAZAN: LatLng(55.78874, 49.12214),
      PlaceFilterScreen.YEKATERINBURG: LatLng(56.8519, 60.6122)
    };
    _imageApi = ImageApi();
    _geolocator = Geolocator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then((sp) {
        _token = sp.getString(ConstantsManager.TOKEN_KEY);
        Filter.savedFilter().then((filter) {
          if (filter?.place != null) {
            setState(() {
              _userLocation = _cities[filter.place];
            });
          }
          _coWorkingApi
              .searchCoWorkingPlaces(_token, _showAsList,
                  filter: filter,
                  location: _cities[filter?.place] ?? _userLocation)
              .then((coWorkings) {
            if (coWorkings != null && coWorkings.length > 0) {
              setState(() {
                for (CoWorking c in coWorkings) {
                  if (!coWorkingIds.contains(c.id)) {
                    coWorkingIds.add(c.id);
                    this._coWorkings.add(c);
                  }
                }
                _isLoading = false;
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          }).catchError((error) {
            _showToast(stringResources.mServerError);
            print('coworking search error: $error');
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stringResources = StringResources.of(context);
    _cities[stringResources.tWherever] = null;
    _cities[stringResources.tNearby] = _userLocation;
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              _showAsList ? Icons.place : Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showAsList = !_showAsList;
              });
            }),
        title: Text(
//          stringResources.tPlace,
          'Desk4work',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () => _openFilter())
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(
              top: _showAsList ? (_screenHeight * .029985) : .0),
          child: _isLoading
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : (_coWorkings.length > 0)
                  ? (_showAsList ? _showList() : _showMap())
                  : Container(
                      child: Center(
                        child: Text((_locationError &&
                                _filter != null &&
                                _filter.place == stringResources.tNearby)
                            ? stringResources.mUnableToAccessLocation
                            : stringResources.tNothingToShow),
                      ),
                    )),
    );
  }

  RefreshIndicator _showList() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
//        shrinkWrap: true,
          itemCount: _coWorkings.length,
          itemBuilder: (ctx, index) {
            if (index == _coWorkings.length - 2 && _shouldLoadMore)
              _loadMoreBooking(true);
            return _getCoWorkingCard(_coWorkings[index]);
          }),
    );
  }

  Future<Null> _refresh() {
    print('refreshing.....');
    return SharedPreferences.getInstance().then((sp) {
      _token = sp.getString(ConstantsManager.TOKEN_KEY);
      Filter.savedFilter().then((filter) {
        print('filterrrr....$filter');
        return _coWorkingApi
            .searchCoWorkingPlaces(_token, _showAsList,
                filter: filter,
                location: _cities[filter?.place] ?? _userLocation)
            .then((coWorkings) {
          if (coWorkings != null && coWorkings.length > 0) {
            setState(() {
              this._coWorkings = [];
              coWorkingIds.clear();
              this._coWorkings.addAll(coWorkings);
              coWorkings.forEach((c) {
                coWorkingIds.add(c.id);
              });
              _isLoading = false;
              _shouldLoadMore = true;
            });
            return null;
          }
        }).catchError((error) {
          _showToast(stringResources.mServerError);
          print('coworking search error: $error');
          return null;
        });
      });
    });
  }

  CoWorkingPlaceMapScreen _showMap() {
    LatLng defautPosition = (_filter != null &&
            _filter.place != null &&
            _filter.place != stringResources.tWherever)
        ? _cities[_filter.place]
        : _userLocation;
    print('default location: $defautPosition');
    return CoWorkingPlaceMapScreen(
      _coWorkings,
      defaultPosition: defautPosition,
    );
  }

  Future _loadMoreBooking(bool withOffSet) {
    if (_shouldLoadMore) {
      return Filter.savedFilter().then((filter) {
        print('filter:: $filter');
        return SharedPreferences.getInstance().then((sp) {
          _token = sp.getString(ConstantsManager.TOKEN_KEY);
          if (filter != null && filter.place == stringResources.tNearby) {
            print(' doing thissss; ................');
            print(
                ' doing thissss filter place; ................${filter.place}');
            print(
                ' doing thissss nearby; ................${stringResources.tNearby}');
            try {
              _geolocator
                  .getCurrentPosition()
                  .then((pos) {
                    if (pos != null) {
                      setState(() {
                        _locationError = false;
                        _userLocation = LatLng(pos.latitude, pos.longitude);
                      });
                    }
                  })
                  .catchError((error) {
                    print('can\'t get location: $error');
                    setState(() {
                      _locationError = true;
                      _coWorkings = [];
                    });
                  })
                  .timeout(Duration(seconds: 5))
                  .whenComplete(() {
                    return _coWorkingApi
                        .searchCoWorkingPlaces(_token, _showAsList,
                            location:
                                _cities[filter?.place], // ?? _userLocation,
                            filter: filter,
                            offset: withOffSet ? _coWorkings.length : 0)
                        .then((coWorkings) {
                      print(' loaded 1: $coWorkings');
                      if (coWorkings != null && coWorkings.length > 0) {
                        setState(() {
                          _isLoading = false;
                          _locationError = false;
                          coWorkings.forEach((coWorking) {
                            if (!this.coWorkingIds.contains(coWorking.id)) {
                              this._coWorkings.add(coWorking);
                              coWorkingIds.add(coWorking.id);
                            }
                          });
//                    this._coWorkings.addAll(coWorkings);
                        });
                      } else {
                        setState(() {
                          _isLoading = false;
                          _shouldLoadMore = false;
                        });
                      }
                    }).catchError((_) {
                      print('loadding error $_');
                      _showMessage(stringResources.eServer);
                    });
                  });
            } catch (e) {
              print('location error: $e');
            }
          } else {
            return _coWorkingApi
                .searchCoWorkingPlaces(_token, _showAsList,
                    location: _cities[filter?.place], // ?? _userLocation,
                    filter: filter,
                    offset: withOffSet ? _coWorkings.length : 0)
                .then((coWorkings) {
              print(' loaded 2: $coWorkings');
              if (coWorkings != null && coWorkings.length > 0) {
                setState(() {
                  _isLoading = false;
                  coWorkings.forEach((coWorking) {
                    if (!coWorkingIds.contains(coWorking.id)) {
                      this._coWorkings.add(coWorking);
                      coWorkingIds.add(coWorking.id);
                    }
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                  _shouldLoadMore = false;
                });
              }
            }).catchError((_) {
              print('loadding error $_');
              _showMessage(stringResources.eServer);
            });
          }
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      return Future.value(null);
    }
  }

  _openFilter() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => FilterRoot()))
        .then((shouldSearch) {
      if (shouldSearch != null && shouldSearch[0]) {
        Filter filter = shouldSearch[1];
        setState(() {
          this._filter = filter;
          _coWorkings = [];
          coWorkingIds.clear();
          _isLoading = true;
          _shouldLoadMore = true;
        });
        print('shouldSearch ${shouldSearch[1]}');

        _loadMoreBooking(false);
      } else
        print("do nothing");
    });
  }

  Future<List<CoWorking>> _getCoWorkings() {
    return SharedPreferences.getInstance().then((sp) {
      _token = sp.getString(ConstantsManager.TOKEN_KEY);
      return _coWorkingApi
          .searchCoWorkingPlaces(_token, _showAsList,
              location: _cities[_filter?.place], // ?? _userLocation,
              filter: _filter)
          .then((coWorkings) {
        return coWorkings;
      }).catchError((error) {
        _showToast(stringResources.mServerError);
        print('coworking search error: $error');
      });
    });
  }

  Widget _getCoWorkingCard(CoWorking coWorking) {
    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * .015),
      height: (_screenHeight * .448),
//      padding: EdgeInsets.only(bottom: .015),
      child: InkWell(
        onTap: () => _openDetails(coWorking),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(0.0))),
          margin: const EdgeInsets.all(0.0),
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Hero(
                        tag:
                            'coWorkingImage-id${coWorking.id}${DateTime.now().millisecondsSinceEpoch} ${coWorking.imageId ?? DateTime.now().millisecondsSinceEpoch}',
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          placeholder: Image.asset(
                            'assets/placeholder.png',
                            height: (_screenHeight * .32),
                          ),
                          height: (_screenHeight * .32),
                          errorWidget: Icon(
                            Icons.error,
                            size: (_screenHeight * .32),
                          ),
                          imageUrl: ConstantsManager.BASE_URL +
                              "images/get_full/${coWorking.imageId}",
                        )),
                  )
//                  _buildImage(coWorking.imageId)
                ],
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: (_screenWidth * .048)),
                height: _screenHeight * .125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: _screenHeight * .009)),
                    Row(
                      children: <Widget>[
                        Text(
                          coWorking.fullName ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
//                        TODO: get the distance and add it to the end
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: _screenHeight * .009)),
                    Row(
                      children: <Widget>[
                        Container(
                          width: _screenWidth * .632,
                          child: Text(
                            coWorking.address ?? " ",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: _screenHeight * .009)),
                    Row(
                      children: <Widget>[_getTime(coWorking)],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  _showToast(String message) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  _openDetails(CoWorking coWorking) {
    SharedPreferences.getInstance().then((sp) {
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoWorkingDetailsScreen(coWorking, token)));
    });
  }

  List<String> _getWorkingDay(CoWorking coWorking) {
    List<WorkingDays> workingDaysList = coWorking.workingDays;
    if (workingDaysList != null && workingDaysList.length > 0) {
      int today = DateTime.now().weekday;
      Map<String, List<String>> workingDaysMap = {};
      coWorking.workingDays.forEach((workingDay) {
        workingDaysMap[workingDay.day] = [
          workingDay.beginWork,
          workingDay.endWork
        ];
      });
      switch (today) {
        case 1:
          return workingDaysMap[ConstantsManager.MONDAY];
        case 2:
          return workingDaysMap[ConstantsManager.TUESDAY];
        case 3:
          return workingDaysMap[ConstantsManager.WEDNESDAY];
        case 4:
          return workingDaysMap[ConstantsManager.THURSDAY];
        case 5:
          return workingDaysMap[ConstantsManager.FRIDAY];
        case 6:
          return workingDaysMap[ConstantsManager.SATURDAY];
        case 7:
          return workingDaysMap[ConstantsManager.SUNDAY];
      }
    }
    return null;
  }

  Widget _getTime(CoWorking coWorking) {
    List<String> endAndStartTIme = _getWorkingDay(coWorking);
    String isClosedText = stringResources.tClosed;
    Color color = Colors.red;
    String text = isClosedText;
    if (endAndStartTIme != null && endAndStartTIme.length > 0) {
      String startTime = endAndStartTIme[0];
      String endTime = endAndStartTIme[1];
      DateTime now = DateTime.now();
      int startHours = int.parse(startTime.substring(0, 2));
      int startMinute = int.parse(startTime.substring(3));
      DateTime startDate =
          DateTime(now.year, now.month, now.day, startHours, startMinute);

      int endHours = int.parse(endTime.substring(0, 2));
      int endMinute = int.parse(endTime.substring(3));
      DateTime endDate =
          DateTime(now.year, now.month, now.day, endHours, endMinute);

      bool isClosed = (startDate.isAfter(now) || endDate.isBefore(now));
      color = isClosed ? Colors.red : Colors.green;

      text = "${(startHours < 10) ? "0" + startHours.toString() : startHours}:"
          "${(startMinute < 10) ? "0" + startMinute.toString() : startMinute}" +
          '-' +
          "${(endHours < 10) ? '0' + endHours.toString() : endHours}:"
          "${(endMinute < 10) ? '0' + endMinute.toString() : endMinute}";
      text = (isClosed) ? text + "(" + isClosedText + ")" : text;
    }
    return Text(text,
        style: Theme.of(context).textTheme.caption.copyWith(color: color));
  }

  Future<String> _getPictureUrl(int id) {
    return _imageApi.getImage(_token, id);
  }

  Widget _buildImage(int imageId) {
    return FutureBuilder<String>(
      future: _getPictureUrl(imageId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _showMessage(stringResources.mNoInternet);
          case ConnectionState.waiting:
            return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50.0),
                child: new CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              print("error  loading coWorkings picture ${snapshot.error}");
              return Expanded(
                child: Hero(
                  tag: 'coWorkingImage-id $imageId',
                  child: Icon(
                    Icons.error,
                    size: (_screenHeight * .23),
                  ),
                ),
              );
            } else {
              if (snapshot.data == null)
                return Expanded(
                  child: Hero(
                    tag: 'coWorkingImage-id $imageId',
                    child: Image.asset(
                      'assets/placeholder.png',
                      height: (_screenHeight * .23),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _coWorkings.length,
                    itemBuilder: (ctx, index) {
                      return Expanded(
                        child: Hero(
                            tag: 'coWorkingImage-id $imageId',
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: Image.asset(
                                'assets/placeholder.png',
                                height: (_screenHeight * .23),
                              ),
                              height: (_screenHeight * .23),
                              errorWidget: Icon(
                                Icons.error,
                                size: (_screenHeight * .23),
                              ),
                              imageUrl: snapshot.data,
                            )),
                      );
                    });
              }
            }
            break;
          case ConnectionState.active:
            break;
        }
      },
    );
  }
}
