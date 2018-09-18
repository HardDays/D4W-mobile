import 'dart:async';

import 'package:desk4work/api/auth_api.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/orange_gradient.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _screenKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Size _screenSize;
  AuthApi _authApi = AuthApi();
  int _attempts = 1;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              width: _screenSize.width,
              padding: EdgeInsets.only(top: (_screenSize.height * .1169).toDouble()),
              decoration: OrangeGradient.getGradient(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/logo_horizontal.png',
                    width: (_screenSize.width * .5573),
                    height: (_screenSize.height * .1079),
                    fit: BoxFit.fill,
                  ),
                  _getLoginForm(),
                  Container(
                    margin: EdgeInsets.only(top: (_screenSize.height * .0165).toDouble()),
                    width: (_screenSize.width * .84).toDouble(),
                    child: InkWell(
                      child: Text(
                        StringResources.of(context).tForgotPassword,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _openPasswordRecovery();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: (_screenSize.height * .0255).toDouble()),
                    width: (_screenSize.width * .84).toDouble(),
                    height: (_screenSize.height * .0825).toDouble(),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(28.0))),
                    child: Center(
                      child: InkWell(
                        child: Text(
                          StringResources.of(context).bEnter,
                          style: TextStyle(color: Colors.orange),
                        ),
                        onTap: () {
                          if (_formKey.currentState.validate()) _sendForm();
                        },
                      ),
                    )),
                  Container(
                    margin: EdgeInsets.only(top: (_screenSize.height * .069).toDouble()),
                    child: Text(StringResources.of(context).tSocialLogin,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top :(_screenSize.height * .0255).toDouble()),
                    width: (_screenSize.width * .3893).toDouble(),
                    height: (_screenSize.height * .0510).toDouble(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Image.asset(
                            'assets/google_plus.png',
                            width: (_screenSize.width * .08).toDouble(),
                            height: (_screenSize.height * .0299).toDouble(),
                            fit: BoxFit.scaleDown,
                          ),
                          onTap: () {
                            _handleGoogleSignIn();
                          },
                        ),
                        InkWell(
                          child: Image.asset(
                            'assets/facebook.png',
                            width: (_screenSize.width * .0453).toDouble(),
                            height: (_screenSize.height * .04).toDouble(),
                          ),
                          onTap: () {
                            _handleFacebookSignIn();
                          },
                        ),
                        InkWell(
                          child: Image.asset(
                            'assets/vk_social_network.png',
                            width: (_screenSize.width * .0853).toDouble(),
                            height: (_screenSize.height * .027).toDouble(),
                          ),
                          onTap: () {
                            _handleVkSignIn();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            clipper: BottomCurveClipper(),
          ),
          PositionedDirectional(
            bottom: 0.0,
            child: Container(
                width: _screenSize.width,
                height: (_screenSize.height * .1214).toDouble(),
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: InkWell(
                    child: Text(
                      StringResources.of(context).bRegister,
                      style: TextStyle(color: Colors.orange),
                    ),
                    onTap: () => _openRegistrationScreen(),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }



  Widget _getLoginForm() {
    return Container(
      margin: EdgeInsets.only(top: (_screenSize.height * .087).toDouble()),
      width: (_screenSize.width * .84).toDouble(),
      child: Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28.0))
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
              hintStyle: TextStyle(color: Colors.white),
              hintText: StringResources.of(context).hLogin,
            ),
            validator: (login) {
              if (login.isEmpty) return StringResources.of(context).eEmptyLogin;
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: (_screenSize.height * .014).toDouble()),
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28.0)),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
                hintStyle: TextStyle(color: Colors.white),
                hintText: StringResources.of(context).hPassword),
            validator: (password) {
              if (password.isEmpty)
                return StringResources.of(context).eEmptyPassword;
            },
          )
        ],
      ),)
    );
  }

  _sendForm() {
    String email = _emailController.text;
    String password = _passwordController.text;
    _authApi
        .login(email, password)
        .then((response) => _handleServerResponse(response));
  }

  _handleServerResponse(Map<String, String> serverResult) {
    if (serverResult != null) {
      if (serverResult['token'] != null) {
        SharedPreferences.getInstance().then((sp) {
          sp.setString(ConstantsManager.TOKEN_KEY, serverResult['token'])
              .then((hasAdded) {
            if (hasAdded)
              _openMainScreen();
            else {
              if (_attempts == 1) {
                _attempts--;
                _handleServerResponse(serverResult);
              } else
                _showToast("ERROR"); //TODO
            }
          });
        });
      } else if (serverResult['error'] != null) {
        int error = int.parse(serverResult['error']);
        if (error == 401)
          _showToast("Unauthorized");
        else
          _showToast('ERROR');
      }
    } else
      _showToast('ERROR');
  }

  _handleGoogleSignIn() {}

  _handleFacebookSignIn() {}

  _handleVkSignIn() {}

  _openMainScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => MainScreen()));
  }

  _openRegistrationScreen() {
    Navigator.of(context).pushNamed('/register');
  }

  _openPasswordRecovery() {
//    TODO
  }

  _showToast(String message) {
//    TODO
  }
}

class BottomCurveClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path path = Path();
    double upperHeight = (size.height * .8786).toDouble();
    path.lineTo(.0, upperHeight - 24.0);
    var leftControlPoint = Offset(size.width/4, upperHeight - 4.0);
    var startPoint = Offset(size.width/2.0, upperHeight - 2.0 );
    path.quadraticBezierTo(leftControlPoint.dx, leftControlPoint.dy, startPoint.dx, startPoint.dy);
    var rightControlPoint = Offset((size.width/4) * 3.0, upperHeight -4.0);
    var endPoint = Offset(size.width, upperHeight - 24.0);
    path.quadraticBezierTo(rightControlPoint.dx, rightControlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}
