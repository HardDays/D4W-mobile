import 'package:flutter/material.dart';

class SnackBarShower {
  static ScaffoldFeatureController showMessage(GlobalKey<ScaffoldState> scaffoldState,
      String message){
    return scaffoldState.currentState.showSnackBar(SnackBar(content: Text(message)));

  }
}