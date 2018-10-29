import 'dart:async';

import 'package:desk4work/api/auth_api.dart';
import 'package:desk4work/api/vkapi/lib/vkapi.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/curved_clipper.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



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
  var auth = StandaloneAuth();
  StreamSubscription<String> _onUrlChanged;
  final FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();
  String _authToken;
  bool _isLoading, _autoValidate;
  StringResources _stringResources;
  final GoogleSignIn _googleSignIn =GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount _googleSignInAccount;

  @override
  void initState() {
    _isLoading = false;
    _autoValidate = false;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      setState(() {
        _googleSignInAccount = account;
      });
      if(_googleSignInAccount !=null){
        _handleGoogleSignIn();
      }else{
        print('user changed account null');
      }
      _googleSignIn.signInSilently();
    });
    super.initState();

    try {
      flutterWebViewPlugin.close();
    } catch (e) {
      print('close webview error : $e');
    } finally {
      _initOnRedirect();
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _stringResources = StringResources.of(context);
    return Scaffold(
      key: _screenKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: (_isLoading)
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    width: _screenSize.width,
                    padding: EdgeInsets.only(
                        top: (_screenSize.height * .1169).toDouble()),
                    decoration: BoxDecorationUtil.getOrangeGradient(),
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
                          margin: EdgeInsets.only(
                              top: (_screenSize.height * .0165).toDouble()),
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
                            margin: EdgeInsets.only(
                                top: (_screenSize.height * .0255).toDouble()),
                            width: (_screenSize.width * .84).toDouble(),
                            height: (_screenSize.height * .0825).toDouble(),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28.0))),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate())
                                  _sendForm();
                                else{
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  StringResources.of(context).bEnter,
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              top: (_screenSize.height * .069).toDouble()),
                          child: Text(
                            StringResources.of(context).tSocialLogin,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: (_screenSize.height * .0255).toDouble()),
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
                                  height:
                                      (_screenSize.height * .0299).toDouble(),
                                  fit: BoxFit.scaleDown,
                                ),
                                onTap: () {
                                  _startGoogleSignInProcess();
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
                                  height:
                                      (_screenSize.height * .027).toDouble(),
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
                  clipper:
                      CurvedClipper((_screenSize.height * .8786).toDouble()),
                ),
                PositionedDirectional(
                  bottom: 0.0,
                  child: InkWell(
                    onTap: () => _openRegistrationScreen(),
                    child: Container(
                        width: _screenSize.width,
                        height: (_screenSize.height * .1214).toDouble(),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Text(
                            StringResources.of(context).bRegister,
                            style: TextStyle(color: Colors.orange),
                          ),
                        )),
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
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28.0))),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: StringResources.of(context).hEmail,
                ),
                style: TextStyle(color: Colors.white),
                validator: (login) {
                  if (login.isEmpty)
                    return StringResources.of(context).eEmptyLogin;
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
                      r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
                      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(login?.trim()))
                    return StringResources.of(context).eWrongEmailFormat;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: (_screenSize.height * .014).toDouble()),
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: StringResources.of(context).hPassword),
                validator: (password) {
                  if (password.isEmpty || password.length <6)
                    return StringResources.of(context).eShortPassword;
                },
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }

  _sendForm() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    setState(() {
      _isLoading = true;
    });
    try {
      _authApi
          .login(email, password)
          .then((response) => _handleServerResponse(response))
          .catchError((error){
            print('login error : $error');
            setState(() {
              _isLoading = false;
            });
            _showToast(_stringResources.eServer);
      });
    } catch (e) {
      print("login error: $e");
      setState(() {
        _isLoading = false;
      });
      _showToast(_stringResources.eServer);
    }
  }

  _handleServerResponse(Map<String, String> serverResult) {
    if (serverResult != null) {
      if (serverResult['token'] != null) {
        SharedPreferences.getInstance().then((sp) {
          sp.setString(ConstantsManager.FIRST_NAME,
              serverResult[ConstantsManager.FIRST_NAME]);
          sp.setString(ConstantsManager.TOKEN_KEY,
              serverResult[ConstantsManager.TOKEN_KEY]);
          _openMainScreen();
        });
      } else if (serverResult[ConstantsManager.SERVER_ERROR] != null) {
        int error = int.parse(serverResult[ConstantsManager.SERVER_ERROR]);
        if (error == 401)
          _showToast(_stringResources.eBadCredentials);
        else
          _showToast(_stringResources.eServer);
      }
    } else
      _showToast(_stringResources.eServer);
  }
  
  _startGoogleSignInProcess() async{
    _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await _googleSignInAccount.authentication;
    FirebaseUser user = await _firebaseAuth.signInWithGoogle(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
   print('$googleSignInAuthentication');
  }

  _handleGoogleSignIn() {
      print(' infooooooo ');

    _googleSignInAccount.authentication.then((GoogleSignInAuthentication authentication){
      String idToken = authentication.idToken;
      String accessToken = authentication.accessToken;
      String email = _googleSignInAccount.email;

      print(' infooooooo $accessToken');
      _authApi.googleLogin(accessToken).then((token) {
        SharedPreferences.getInstance().then((sp) {
          sp.setString(ConstantsManager.TOKEN_KEY, token).then((_) {
            _openMainScreen();
          });
        });
      });
    });

  }

  _handleFacebookSignIn() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");

        String facebookToken = facebookLoginResult.accessToken.token;
        _authApi.vkOrFacebookLogin(facebookToken, true).then((token) {
          print('facetoken $token');
          SharedPreferences.getInstance().then((sp) {
            sp.setString(ConstantsManager.TOKEN_KEY, token).then((_) {
              _openMainScreen();
            });
          });
        });
        onLoginStatusChanged(true);
        break;
    }

  }

  _handleVkSignIn() {
    try {
      print('${ConstantsManager.VK_APPLICATION_ID}');
      auth
        ..appId = '${ConstantsManager.VK_APPLICATION_ID}'
        ..version = '5.27'
        ..redirectUri = "https://oauth.vk.com/blank.html"
        ..secret = ConstantsManager.VK_APPLICATION_KEY
        ..scopes = [Scope.Email, Scope.Offline];

      String url = auth.authUri.toString();

      if (_authToken != null && _authToken.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        _authApi.vkOrFacebookLogin(_authToken, false).then((token) {
          SharedPreferences.getInstance().then((sp) {
            sp.setString(ConstantsManager.TOKEN_KEY, token).then((_) {
              _openMainScreen();
            });
          });
        });
      } else {
        flutterWebViewPlugin.launch(url, withZoom: true);
      }
    } catch (e) {
      print("shit happened: $e");
    }
  }

  void _initOnRedirect() {
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      try {
        if (auth.getToken(url) != null) {
          if (RegExp(r'access_token=([\w\d]+)').firstMatch(url) != null) {
            setState(() {
              _authToken = new RegExp(r'access_token=([\w\d]+)')
                  .firstMatch(url)
                  .group(1);
            });

            flutterWebViewPlugin.close().then((_){
              _handleVkSignIn();
            });
          }
        }
      } catch (e) {
        print('vk login exception : $e');
      }
    });
  }

  _openMainScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => MainScreen()));
  }

  _openRegistrationScreen() {
    Navigator.of(context).pushNamed('/register');
  }

  _openPasswordRecovery() {
    Navigator.of(context).pushNamed('/recover');
  }

  _showToast(String message) {
    setState(() {
      _isLoading = false;
    });
    _screenKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onLoginStatusChanged(bool param0) {}
}
