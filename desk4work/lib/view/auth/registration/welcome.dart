import 'dart:async';

import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';


class WelcomeScreen extends StatelessWidget{

  final String _name;
  const WelcomeScreen(this._name);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    return Container(
      margin: EdgeInsets.only(top: (screenHeight * .1849).toDouble()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo_horizontal_color_no_shade.png',
            width: (screenWidth * .5573).toDouble(),
            height: (screenHeight * .1079).toDouble(),
            fit: BoxFit.fill,
          ),
          Padding(padding: EdgeInsets.only(top: (screenHeight * .1019).toDouble())),
          Text((StringResources.of(context).tHello + _name + '!').toUpperCase(),
            style: TextStyle(color: Colors.orange,
                fontSize: (screenHeight * .0435).toDouble()) ),
          Padding(padding: EdgeInsets.only(top: (screenHeight * .042).toDouble()),),
          Center(
            child: Text((StringResources.of(context).tSuccessfulRegistration),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subhead,),
          )
        ],
      ),
    );
  }

}