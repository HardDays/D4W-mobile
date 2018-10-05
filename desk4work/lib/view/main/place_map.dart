import 'dart:async';

import 'package:desk4work/api/coworking_api.dart';
import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:latlong/latlong.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/main/co_working_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class CoWorkingPlaceMapScreen extends StatefulWidget {
  List<CoWorking> _coworkings;

  CoWorkingPlaceMapScreen(List<CoWorking> coworkings){
    _coworkings = (coworkings ?? []).where((cw)=> cw.lat != null && cw.lng != null).toList();
  }

  @override
  State<StatefulWidget> createState() => _CoWorkingPlaceMapScreenState();
}

class _CoWorkingPlaceMapScreenState extends State<CoWorkingPlaceMapScreen> {

  static const String _mapBoxUrl = "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}";
  static const String _mapBoxToken = "pk.eyJ1Ijoidm92YW4xMjMiLCJhIjoiY2o3aXNicTFhMW9jbDJxbWw3bHNqMW92MCJ9.N1hCLnBrJjdX0JmYuA8bOw";
  static const String _mapBoxId = "mapbox.streets";

  MapController _mapController = MapController();
  CoWorkingApi _coWorkingApi = CoWorkingApi();
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources stringResources;
  Size _screenSize ;
  CoWorking _coworking;
  Geolocator _geolocator;
  LatLng _lastPos;
  double _screenHeight, _screenWidth;
  bool _cardShowing = false;

  @override
  void initState(){
    super.initState();

    _geolocator = Geolocator();
    _mapController.onReady.then(
      (ready){
        _geolocator.getCurrentPosition().then((pos){
          if (pos != null){
            setState(() {                                     
              _lastPos = LatLng(pos.latitude, pos.longitude);
              _mapController.move(_lastPos, 13.0);
            });
          }
        }).timeout(Duration(seconds: 5));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text(
          stringResources.tMap,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[]
      ),
      body: _buildCoWorkingMap(),
    );
  }
  
  Widget _buildCoWorkingMap(){
    return Container(
      child: Stack(
        children: [
          Container(    
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
              zoom: 3.0,
              onTap: (pos){
                setState(() {
                  _cardShowing = false;
                  _coworking = null;                       
                });                         
              },
              onPositionChanged: (pos){
                if (_cardShowing){
                  setState(() {
                    _cardShowing = false;
                    _coworking = null;                       
                  }); 
                } 
              }             
            ),                 
            layers: [
              TileLayerOptions(
                urlTemplate: _mapBoxUrl,
                additionalOptions: {
                  'accessToken': _mapBoxToken,
                  'id': _mapBoxId,
                },
              ),
              MarkerLayerOptions(
                markers: List.generate(widget._coworkings.length, 
                  (ind){
                    var cw = widget._coworkings[ind];
                    return Marker(
                      point: LatLng(cw.lat, cw.lng),                   
                      builder: (ctx) =>  GestureDetector(
                        onTap: (){
                          setState(() {
                            _mapController.move(LatLng(cw.lat, cw.lng), _mapController.zoom);
                            _cardShowing = true;
                            _coworking = cw;                       
                          });
                        },
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                                image: AssetImage('assets/pin_orange.png'),
                              ),
                            ),
                          )
                        )
                      );             
                    }
                  )..add(
                    _buildUserMarker()
                  )
                )
              ]
            )
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(170, 255, 255, 255),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Icon(Icons.zoom_in),
                    color: Color.fromARGB(160, 0, 0, 0),
                    onPressed: () {
                      setState(() {
                        _mapController.move(_mapController.center, _mapController.zoom + 0.5);             
                      });
                    },
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(170, 255, 255, 255),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Icon(Icons.zoom_out),
                    color: Color.fromARGB(160, 0, 0, 0),
                    onPressed: () {
                      setState(() {
                        _mapController.move(_mapController.center, _mapController.zoom - 0.5);             
                      });
                    },
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(170, 255, 255, 255),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Icon(Icons.center_focus_strong),
                    color: Color.fromARGB(160, 0, 0, 0),
                    onPressed: () {
                      _geolocator.getLastKnownPosition().then((pos){
                        if (pos != null){
                          setState(() {
                            _lastPos = LatLng(pos.latitude, pos.longitude);
                            _mapController.move(_lastPos, _mapController.zoom); 
                          });
                        } 
                      }).timeout(Duration(seconds: 5));                                  
                    },
                  )
                ),
              ]
            )
          ),
         _getCoWorkingCard()
        ],
      ),
    );
  }
  
  Widget _getCoWorkingCard(){
    if (_cardShowing){
      return GestureDetector(
        onTap: (){
          _openDetails(_coworking);
        },
        child: Container(
          alignment: Alignment.center,
          height: _screenHeight,
          child: Container(
            margin: EdgeInsets.only(bottom: _screenHeight * 0.2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6.0))
            ),
            width: _screenWidth * 0.7,
            height: _screenHeight * 0.11,
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: _screenHeight * 0.11,
                    height: _screenHeight * 0.11,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                      child: _coworking.imageId != null ?  CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: Image.asset('assets/placeholder.png',
                          width: _screenHeight * 0.11,
                          height: _screenHeight * 0.11,                        
                        ),
                        errorWidget: Image.asset('assets/placeholder.png',
                          width: _screenHeight * 0.11,
                          height: _screenHeight * 0.11,                        
                        ),
                        imageUrl: ConstantsManager.IMAGE_BASE_URL + "${_coworking.imageId}"                
                      ) : 
                      Image.asset('assets/placeholder.png',
                        width: _screenHeight * 0.11,
                        height: _screenHeight * 0.11,                        
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: _screenWidth * 0.45,
                          child: Text(_coworking.shortName ?? _coworking.fullName,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0
                            ),
                          ),
                        ),
                        Container(
                          width: _screenWidth * 0.45,
                          child: Text(_coworking.address ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 13.0
                            ),
                          ),
                        ),
                        Text(_coworking.currentDay != null ? _coworking.currentDay.beginWork + " - " + _coworking.currentDay.endWork : "Closed",
                          style: TextStyle(
                            color: _coworking.currentDay != null ? Colors.green.withAlpha(180) : Colors.red.withAlpha(180),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          )
        )
      );
    } else {
      return Container();
    }
  }

  Marker _buildUserMarker(){
    if (_lastPos != null){
      return Marker(
        width: 15.0,
        height: 15.0,
        point: _lastPos,                
        builder: (ctx) => 
          Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withAlpha(200)
            )
          )
        );
      } else {
        return Marker(point: LatLng(59.1, 49.1), builder: (ctx) => Container());
      } 
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
}
