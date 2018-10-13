import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/auth/registration/registration.dart';
import 'package:desk4work/view/auth/registration/welcome.dart';
import 'package:desk4work/view/common/curved_clipper.dart';
import 'package:flutter/material.dart';

class RegistrationMainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RegistrationMainScreenState();


}

class RegistrationMainScreenState extends State<RegistrationMainScreen>{
  var _screenKey = GlobalKey<ScaffoldState>();
  Size _screenSize;
  String _username;


  @override
  void initState() {
    _username = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    double clipperHeight = (_screenSize.height * .1514).toDouble();
    return Theme(
      data: Theme.of(context).copyWith(
        hintColor: Colors.grey,

      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipPath(
                child: InkWell(
                  child: Container(
                    color: Colors.orange,
                    height: clipperHeight,
                    padding: EdgeInsets.only(top: (_screenSize.height * .0405).toDouble()),
                    child: Center(
                      child: Text(StringResources.of(context).bEnter,
                        style: TextStyle(color: Colors.white) ,),
                    ),
                  ),
                  onTap: ()=>_openLogin(),
                ),
                clipper: CurvedClipper(clipperHeight),
              ),
            ),
            Container(
              width: (_screenSize.width * .84).toDouble(),
              height: _screenSize.height - clipperHeight,
              child: (_username == null) ?RegistrationScreen() : WelcomeScreen(_username),
            )
          ],
        ),
      ),
    );

  }

  _openLogin(){
    Navigator.of(context).pop();
  }

}