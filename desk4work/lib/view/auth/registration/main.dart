import 'dart:async';

import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/auth/registration/registration.dart';
import 'package:desk4work/view/auth/registration/welcome.dart';
import 'package:desk4work/view/common/curved_clipper.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';

class RegistrationMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationMainScreenState();
}

class RegistrationMainScreenState extends State<RegistrationMainScreen> {
  var _screenKey = GlobalKey<ScaffoldState>();
  Size _screenSize;
  String _username;
  bool _isRegistered;

  @override
  void initState() {
    _username = null;
    _isRegistered = false;
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
                    padding: EdgeInsets.only(
                        top: (_screenSize.height * .0405).toDouble()),
                    child: Center(
                      child: Text(
                        !_isRegistered
                            ? StringResources.of(context).bBack
                            : StringResources.of(context).bEnter,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () => _openLoginOrMain(),
                ),
                clipper: CurvedClipper(clipperHeight),
              ),
            ),
            Container(
              width: (_screenSize.width * .84).toDouble(),
              height: _screenSize.height - clipperHeight,
              child: (_username == null)
                  ? RegistrationScreen((firstname) {
                      _showWelcome(firstname);
                    })
                  : WelcomeScreen(_username),
            )
          ],
        ),
      ),
    );
  }

  _showWelcome(firstName) {
    print('firstname : $firstName');
    setState(() {
      _isRegistered = true;
    });
    int count = 2;
    Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (count > 0)
        count--;
      else {
        setState(() {
          _username = firstName;
        });
        t.cancel();
      }
    });
  }

  _openLoginOrMain() {
    _isRegistered
        ? Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => MainScreen()))
        : Navigator.of(context).pop();
  }
}
