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

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  final Key _searchState = PageStorageKey(ConstantsManager.SEARCH_KEY);
  final Key _reservationListState = PageStorageKey(ConstantsManager.RESERVATION_LIST_KEY);
  final Key _profileState = PageStorageKey(ConstantsManager.PROFILE_KEY);
  final PageStorageBucket storageBucket = PageStorageBucket();
  TabController _tabController;
  int _currentTab = 0;
  List<Widget> _tabs;
  Widget _currentPage;

  BookingApi _bookingApi = BookingApi();
  StringResources stringResources;

  List<Booking> _bookings;


  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabs =[_getCoWorkingBuilder(), _getBookingsBuilder(), _getProfileBuilder()];
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
      child: Scaffold(
        key: scaffoldState,
        body: PageStorage(bucket: storageBucket, child: _currentPage),
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  Widget _getCoWorkingBuilder(){
    return CoWorkingPlaceListScreen();
  }

  FutureBuilder<List<Booking>> _getBookingsBuilder(){

    return FutureBuilder<List<Booking>>(
        future: _getBookings(),
        builder: (cxt, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none :
              return _showMessage(stringResources.mNoInternet);
            case ConnectionState.waiting :
              return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50.0),
                  child: new CircularProgressIndicator()
              );
            case ConnectionState.done:
              if(snapshot.hasError){
                print("error  loading coWorkings ${snapshot.error}");
                return _showMessage(stringResources.mServerError);
              }else{
                if(snapshot.data == null) return Container();
                else {
                  _bookings = snapshot.data;
                  return BookingsListScreen(_bookings);
                }
              }
              break;
            case ConnectionState.active: break;
          }
        });
  }

  Widget _getProfileBuilder(){
    return ProfileMenuScreen();
  }

  Future<List<Booking>> _getBookings(){
    return _getToken().then((token){
      return _bookingApi.getUserBookings(token);
    });
  }

  Future<String> _getToken(){
    return SharedPreferences.getInstance().then((sp){
      return sp.getString(ConstantsManager.TOKEN_KEY);
    });
  }

  BottomNavigationBar _getBottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.orange,
      currentIndex: _currentTab,
      onTap: (index){
        setState(() {
          _currentTab = index;
          _currentPage = _tabs[index];
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Container()
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Container()
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Container()
        ),

      ],
    );
  }


  Widget _showMessage(String message){
    return Center(child: Text(message),);
  }


}