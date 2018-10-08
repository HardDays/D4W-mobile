import 'package:flutter/material.dart';

class Dialogs {
  static void showLoader(BuildContext context){
    showDialog(context: context, 
      child: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 1.0,
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              //valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor)
            ),
          )
        )           
      )
    );
  }
  static void showMessage(BuildContext context, String title, String body, String ok){
    showDialog(context: context, 
      child: AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          FlatButton(
            child: Text(ok),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
        ],
      )
    );
  }
}