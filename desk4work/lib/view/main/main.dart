import 'dart:async';

import 'package:desk4work/api/booking_api.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/model/profile.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/main/bookings_list.dart';
import 'package:desk4work/view/main/place_list.dart';
import 'package:desk4work/view/main/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  final Key _searchState = PageStorageKey(ConstantsManager.SEARCH_KEY);
  final Key _reservationListState =
      PageStorageKey(ConstantsManager.RESERVATION_LIST_KEY);
  final Key _profileState = PageStorageKey(ConstantsManager.PROFILE_KEY);
  final PageStorageBucket storageBucket = PageStorageBucket();
  TabController _tabController;
  int _currentTab = 0;
  List<Widget> _tabs;
  Widget _currentPage;

  BookingApi _bookingApi = BookingApi();
  StringResources stringResources;

  List<Booking> _bookings;
  String _token;

  @override
  void initState() {
//    _tabController = TabController(length: 3, vsync: this);
    _tabs = [
      _getCoWorkingBuilder(),
      _getBookingsBuilder(),
      _getProfileBuilder()
    ];
    _currentPage = _getCoWorkingBuilder();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stringResources = StringResources.of(context);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.white),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldState,
          body: TabBarView(children: _tabs, physics: NeverScrollableScrollPhysics(),),
//            body: PageStorage(bucket: storageBucket, child: _currentPage),
          bottomNavigationBar: _getBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _getCoWorkingBuilder() {
    return CoWorkingPlaceListScreen();
  }

  FutureBuilder<List<Booking>> _getBookingsBuilder() {
    return FutureBuilder<List<Booking>>(
        future: _getBookings(),
        builder: (cxt, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return showMessage(stringResources.mNoInternet);
            case ConnectionState.waiting:
              return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50.0),
                  child: new CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("error  loading bookings ${snapshot.error}");
                return showMessage(stringResources.mServerError);
              } else {
                if (snapshot.data == null)
                  return Container();
                else {
                  _bookings = snapshot.data;
                  return BookingsListScreen(_bookings, _token);
                }
              }
              break;
            case ConnectionState.active:
              break;
          }
        });
  }

  Widget _getProfileBuilder() {
    return ProfileMenuScreen();
  }

  Future<List<Booking>> _getBookings() {
    return _getToken().then((token) {
      return _bookingApi.getUserBookings(token);
    });
  }

  Future<String> _getToken() {
    return SharedPreferences.getInstance().then((sp) {
      if (_token == null) _token = sp.getString(ConstantsManager.TOKEN_KEY);
      return _token;
    });
  }

  TabBar _getBottomNavigationBar() {
    return TabBar(
      tabs: [
        Tab(icon: Icon(Icons.search)),
        Tab(icon: Icon(Icons.assignment)),
        Tab(icon: Icon(Icons.perm_identity)),
      ],
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.white,
      indicatorPadding: EdgeInsets.all(5.0),

    );
//    return BottomNavigationBar(
//      type: BottomNavigationBarType.fixed,
//      fixedColor: Colors.orange,
//      currentIndex: _currentTab,
//      onTap: (index){
//        setState(() {
//          _currentTab = index;
//          _currentPage = _tabs[index];
//        });
//      },
//      items: <BottomNavigationBarItem>[
//        BottomNavigationBarItem(
//            icon: Icon(Icons.search),
//            title: Container()
//        ),
//        BottomNavigationBarItem(
//            icon: Icon(Icons.assignment),
//            title: Container()
//        ),
//        BottomNavigationBarItem(
//            icon: Icon(Icons.perm_identity),
//            title: Container()
//        ),
//
//      ],
//    );
  }

  Widget showMessage(String message) {
    return Center(
      child: Text(message),
    );
  }
}
