import 'dart:async';

import 'package:desk4work/model/co_working.dart';
import 'package:desk4work/utils/string_resources.dart'; 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileMenuScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources stringResources;
  Size _screenSize ;
  double _screenHeight, _screenWidth;

  @override
  void initState(){
    super.initState();

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
      body: _buildProfilePage(),
    );
  }
  
  Widget _buildProfilePage(){
    return Container(
      color: Color(0xFFE5E5E5),
      child: Column(
        children: <Widget>[
          Container(
            height: _screenHeight * 0.17,
            width: _screenWidth,
            decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(
                 color: Colors.grey.withAlpha(100)
               )
            ),
            child: Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: _screenHeight * 0.17 - 40.0,
                    height: _screenHeight * 0.17 - 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                  ),
                  Container(
                    width: _screenWidth - (_screenHeight * 0.17 + 50),
                    margin: EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('First name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0
                          ),
                        ),
                        Text('Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 14.0
                          ),
                        ),
                        Text('Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 14.0
                          ),
                        ) 
                      ],
                    )
                  ),
                  IconButton(
                    iconSize: 20.0,
                    icon: Icon(Icons.arrow_forward_ios)
                  )
                ],
              )
            )
          )
        ],
      ),
    );
  }
  
}