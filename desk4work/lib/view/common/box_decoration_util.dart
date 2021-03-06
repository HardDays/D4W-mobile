import 'package:flutter/material.dart';

class BoxDecorationUtil {
  static BoxDecoration getOrangeGradient(){
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
  static BoxDecoration getDarkOrangeGradient(){
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [.35, .6, .9],
              colors: [
//                Colors.orange[200],
                Colors.orange[400],
                Colors.orange[500],
                Colors.orange[600],
              ]
          )
      );
    }


  static BoxDecoration getGreyRoundedCornerBoxDecoration(){
    return BoxDecoration(
      color: Colors.white12,
      borderRadius: BorderRadius.all(Radius.circular(41.0))
    );
  }

  static BoxDecoration getGreyRoundedWhiteCornerBoxDecoration(){
    return BoxDecoration(
        color: Colors.white12,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(41.0))
    );
  }



  static BoxDecoration getOrangeRoundedCornerBoxDecoration(){
    return BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(41.0))
    );
  }

  static BoxDecoration getOrangeGradientRoundedCornerDecoration(){
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
        ),
        borderRadius: BorderRadius.all(Radius.circular(41.0))
    );
  }

}