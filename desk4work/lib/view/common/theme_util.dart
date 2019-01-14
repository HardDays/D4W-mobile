import 'package:flutter/material.dart';

class ThemeUtil {
  static ThemeData getThemeForOrangeBackground(BuildContext context){
    return Theme.of(context).copyWith(
      textTheme : Theme.of(context).textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      iconTheme: Theme.of(context).iconTheme.copyWith(
        color: Colors.white
      ),
    );
  }


}