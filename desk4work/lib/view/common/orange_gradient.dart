import 'package:flutter/material.dart';

class OrangeGradient {
  static BoxDecoration getGradient(){
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, .35, .6, .9],
            colors: [
              Colors.orange[200],
              Colors.orange[300],
              Colors.orange[500],
              Colors.orange[600],
            ]
        )
    );
  }

}