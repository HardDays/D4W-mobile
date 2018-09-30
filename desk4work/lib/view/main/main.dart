import 'package:desk4work/model/profile.dart';
import 'package:desk4work/model/reservation.dart';
import 'package:desk4work/view/main/place_list.dart';
import 'package:flutter/material.dart';
import 'package:desk4work/utils/constants.dart';

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


  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabs =[_getCoWorkingBuilder(), _getReservationsBuilder(), _getProfileBuilder()];
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

  FutureBuilder<List<Reservation>> _getReservationsBuilder(){

  }

  FutureBuilder<Profile> _getProfileBuilder(){

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



}