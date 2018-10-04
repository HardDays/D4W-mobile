import 'dart:async';

import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/filter/filter_root.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/main/co_working_details.dart';
import 'package:desk4work/view/main/place_map.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CoWorkingPlaceListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoWorkingPlaceListScreenState();
}

class _CoWorkingPlaceListScreenState extends State<CoWorkingPlaceListScreen> {
  List<CoWorking> _coWorkings;
  CoWorkingApi _coWorkingApi = CoWorkingApi();
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources stringResources;
  Size _screenSize ;
  double _screenHeight, _screenWidth;
  
  @override
  Widget build(BuildContext context) {
    stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.place,
              color: Colors.white,
            ),
            onPressed: () => _showOnMap()),
        title: Text(
          stringResources.tPlace,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: ()=>_openFilter())
        ],
      ),
      body: _buildCoWorkingList(),
    );
  }
  
  FutureBuilder<List<CoWorking>> _buildCoWorkingList(){
    return FutureBuilder<List<CoWorking>>(
      future: _getCoWorkings(),
      builder: (ctx, snapshot){
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
                _coWorkings = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: _coWorkings.length,
                    itemBuilder: (ctx,index){
                      return _getCoWorkingCard(_coWorkings[index]);
                    });
              }
            }
            break;
          case ConnectionState.active: break;
        }
      },
    );
  }

  _showOnMap() {
     Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>CoWorkingPlaceMapScreen(_coWorkings)));
  }

  _openFilter() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>FilterRoot()))
        .then((shouldSearch){
          if(shouldSearch !=null && shouldSearch[0]) {
            Filter filter = shouldSearch[1];
            _getCoWorkings(filter: filter).then((coWorkings){
              setState(() {
                _coWorkings = coWorkings;
              });
            });
            print('shouldSearch ${shouldSearch[1]}');
          }
          else print("do nothing");
    });

  }
  
  Future<List<CoWorking>> _getCoWorkings({Filter filter}){
    return SharedPreferences.getInstance().then((sp){
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      return _coWorkingApi.searchCoWorkingPlaces(token, filter: filter).then((coWorkings){
        return coWorkings;
      });
      

    });
  }


  Widget _getCoWorkingCard(CoWorking coWorking){
    return Container(
      height: (_screenHeight * .4273),
      padding: EdgeInsets.only(bottom: .015),
      child: InkWell(
        onTap: ()=> _openDetails(coWorking),
        child: Card(
          shape: const RoundedRectangleBorder(borderRadius:
          const BorderRadius.all(const Radius.circular(0.0))),
          margin: const EdgeInsets.all(0.0),
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Hero(
                        tag: 'coWorking-id ${coWorking.id}',
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          placeholder: Image.asset('assets/placeholder.png',
                            height: (_screenHeight * .23),
                          ),
                          height: (_screenHeight * .23),
                          errorWidget: Icon(Icons.error,size: (_screenHeight * .23),),
                          imageUrl: "",
                        )
                    ),

                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: (_screenWidth * .048)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(coWorking.fullName ?? ""),
//                        TODO: get the distance and add it to the end
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            coWorking.address ?? " ",
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _getTime(coWorking)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showMessage(String message){
    return Center(child: Text(message),);
  }

  _openDetails(CoWorking coWorking){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>CoWorkingDetailsScreen(coWorking)));
  }



  List<String>  _getWorkingDay(CoWorking coWorking){
    List<WorkingDays> workingDaysList = coWorking.workingDays;
    if(workingDaysList != null && workingDaysList.length >0){
      int today = DateTime.now().day;
      Map<String,List<String>> workingDaysMap = {};
      coWorking.workingDays.forEach((workingDay){
        workingDaysMap[workingDay.day] = [workingDay.beginWork, workingDay.endWork];
      });
      switch(today){
        case 1 : return workingDaysMap[ConstantsManager.MONDAY];
        case 2 : return workingDaysMap[ConstantsManager.TUESDAY];
        case 3 : return workingDaysMap[ConstantsManager.WEDNESDAY];
        case 4 : return workingDaysMap[ConstantsManager.THURSDAY];
        case 5 : return workingDaysMap[ConstantsManager.FRIDAY];
        case 6 : return workingDaysMap[ConstantsManager.SATURDAY];
        case 7 : return workingDaysMap[ConstantsManager.SUNDAY];
      }
    }
    return null;
  }

  Widget _getTime(CoWorking coWorking){

    List<String> endAndStartTIme = _getWorkingDay(coWorking);
    String isClosedText = stringResources.tClosed;
    Color color = Colors.red;
    String text= isClosedText;
    if(endAndStartTIme != null && endAndStartTIme.length >0){
      String startTime = endAndStartTIme[0], endTime = endAndStartTIme[1];
      DateTime now = DateTime.now();
      int startHours = int.parse(startTime.substring(0,2));
      int startMinute = int.parse(startTime.substring(3));
      DateTime startDate = DateTime(
          now.year,
          now.month,
          now.day,
          startHours,
          startMinute);

      int endHours = int.parse(endTime.substring(0,2));
      int endMinute = int.parse(endTime.substring(3));
      DateTime endDate = DateTime(
          now.year,
          now.month,
          now.day,
          endHours,
          endMinute);

      bool isClosed = (startDate.isAfter(now) || endDate.isBefore(now));
      color = isClosed ? Colors.red : Colors.green;
      text = "$startHours:$startMinute" + '-'+
          "$endHours:$endMinute";
      text = (isClosed) ?text+"("+ isClosedText + ")" : text;
    }
    return Text(text,
      style: Theme.of(context).textTheme.caption.copyWith(
          color: color));

  }
}
