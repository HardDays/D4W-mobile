import 'package:desk4work/api/auth_api.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/auth/registration/welcome.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  Function(String fistname) _firstNameCallback;

  RegistrationScreen(this._firstNameCallback);

  @override
  State<StatefulWidget> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Size _screenSize;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  int _attempts = 1;
  bool _isLoading, _isRegistered;
  StringResources _stringResources;
  AuthApi _authApi = AuthApi();
  bool _autoValidate;

  @override
  void initState() {
    _isLoading = false;
    _isRegistered = false;
    _autoValidate = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _stringResources = StringResources.of(context);
    return Scaffold(
      key: _scaffoldKey,
//      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              margin:
                  EdgeInsets.only(top: (_screenSize.height * .078).toDouble()),
              width: (_screenSize.width * .84).toDouble(),
              child: Column(
                children: <Widget>[
                  Container(
                    height: (_screenSize.height * .0836).toDouble(),
                    child: Image.asset(
                      'assets/logo_horizontal_color_shaded.png',
                      fit: BoxFit.contain,
                      width: (_screenSize.width * .4311).toDouble(),
                      height: (_screenSize.height * .0836).toDouble(),
                    ),
                  ),
                  Container(
                    height: _screenSize.height * .65,
                    child: ListView(
//                      reverse: true,
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
//                      Image.asset(
//                        'assets/logo_horizontal_color_shaded.png',
//                        fit: BoxFit.contain,
//                        width: (_screenSize.width * .4311).toDouble(),
//                        height: (_screenSize.height * .0836).toDouble(),
//                      ),
                        Container(
                          margin: EdgeInsets.only(
                              top: (_screenSize.height * .0633).toDouble()),
                          child: Form(
                            child: _getForm(),
                            key: _formKey,
                            autovalidate: _autoValidate,
                          ),
                        ),
                        _getSendFormButton(),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: (_screenSize.height * .0735).toDouble()),
                        )
                      ]
//                          .reversed.toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _getForm() {
    double formFieldPaddingVert = (_screenSize.height * .0195).toDouble();
    double formFieldPaddingHor = (_screenSize.width * .0667).toDouble();
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: false,
          controller: _loginController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0))),
            contentPadding: EdgeInsets.symmetric(
                vertical: formFieldPaddingVert,
                horizontal: formFieldPaddingHor),
            hintText: StringResources.of(context).hLogin,
          ),
          validator: (login) {
            if (login.isEmpty) return StringResources.of(context).eEmptyLogin;
            if (login.trim().length > 30)
              return StringResources.of(context).eLongLogin;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: (_screenSize.height * .014).toDouble()),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: formFieldPaddingVert,
                  horizontal: formFieldPaddingHor),
              hintText: StringResources.of(context).hEmail),
          validator: (email) {
            if (email.isEmpty) return StringResources.of(context).eEmptyEmail;
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
                r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
                r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(email))
              return StringResources.of(context).eWrongEmailFormat;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: (_screenSize.height * .014).toDouble()),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: _phoneController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: formFieldPaddingVert,
                  horizontal: formFieldPaddingHor),
              hintText: StringResources.of(context).hPhone),
          validator: (phone) {
            if (phone.isEmpty) return StringResources.of(context).eEmptyPhone;
            if (phone.trim().length > 30)
              return StringResources.of(context).eLongPhoneNumber;
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
              contentPadding: EdgeInsets.symmetric(
                  vertical: formFieldPaddingVert,
                  horizontal: formFieldPaddingHor),
              hintText: StringResources.of(context).hPassword),
          validator: (password) {
            if (password.isEmpty || password.length <6)
              return StringResources.of(context).eEmptyPassword;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: (_screenSize.height * .014).toDouble()),
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordConfirmController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: formFieldPaddingVert,
                  horizontal: formFieldPaddingHor),
              hintText: StringResources.of(context).hPasswordConfirm),
          validator: (passwordConfirm) {
            if (passwordConfirm.isEmpty)
              return StringResources.of(context).eEmptyPasswordConfirm;
            else if(passwordConfirm.length < 6)
              return StringResources.of(context).eShortPasswordConfirm;
            else if (!_passwordsMatching())
              return StringResources.of(context).eNotMatchingPasswords;
          },
        )
      ],
    );
  }

  Widget _getSendFormButton() {
    return _isRegistered
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : InkWell(
            onTap: () {
              if (_formKey.currentState.validate()) _sendForm();
              else {
                setState(() {
                  _autoValidate = true;
                });
              }
            },
            child: Container(
                margin: EdgeInsets.only(
                    top: (_screenSize.height * .0405).toDouble()),
                width: (_screenSize.width * .84).toDouble(),
                height: (_screenSize.height * .0825).toDouble(),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    gradient: BoxDecorationUtil.getOrangeGradient().gradient,
                    borderRadius: BorderRadius.all(Radius.circular(28.0))),
                child: Center(
                  child: Text(
                    StringResources.of(context).bRegister,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          );
  }

  _sendForm() {
    String login = _loginController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String passwordConfirm = _passwordConfirmController.text;

    try {
      setState(() {
        _isLoading = true;
      });
      _authApi
          .register(login, email, phone, password, passwordConfirm)
          .then((response) {
        if (response != null && response[ConstantsManager.EMAIL_KEY] != null) {
          String email = response[ConstantsManager.EMAIL_KEY];
          String firstName = response[ConstantsManager.FIRST_NAME];
          String password = response[ConstantsManager.PASSWORD_KEY];
          SharedPreferences.getInstance().then((sp) {
            sp.setString(ConstantsManager.EMAIL_KEY, email);
            sp.setString(ConstantsManager.FIRST_NAME, firstName);
            sp.setString(ConstantsManager.PASSWORD_KEY, password);
          }).then((_) {
            _authApi.login(email, password).then((serverResult) {
              _handleLoginResponse(serverResult, firstName);
            });
          });
        } else if (response != null &&
            response[ConstantsManager.SERVER_ERROR] != null) {
          if (response[ConstantsManager.SERVER_ERROR] == 'ALREADY_TAKEN')
            _showToast(_stringResources.eTakenEmail);
        } else {
          _showToast(_stringResources.eServer);
          print('registration error: $response');
        }
      }).catchError((_) {
        _showToast(_stringResources.eServer);
        print('registration error: $_');
      });
    } catch (e) {
      print('registration error: $e');
      _showToast(_stringResources.eServer);
    }
  }

  _handleLoginResponse(Map<String, String> serverResult, String firstName) {
    if (serverResult != null) {
      if (serverResult['token'] != null) {
        SharedPreferences.getInstance().then((sp) {
          sp.setString(ConstantsManager.FIRST_NAME,
              serverResult[ConstantsManager.FIRST_NAME]);
          sp
              .setString(ConstantsManager.TOKEN_KEY,
                  serverResult[ConstantsManager.TOKEN_KEY])
              .then((_) {
            setState(() {
//              _isLoading = false;
              _isRegistered = true;
              widget._firstNameCallback(firstName);
            });
          });
        });
      } else if (serverResult['error'] != null) {
        int error = int.parse(serverResult['error']);
        if (error == 401)
          _showToast(_stringResources.eBadCredentials);
        else
          _showToast(_stringResources.eServer);
      }
    } else
      _showToast(_stringResources.eServer);
  }

  bool _passwordsMatching() {
    String password = _passwordController.text;
    String passwordConfirm = _passwordConfirmController.text;
    if (password.length > 0 && passwordConfirm.length > 0) {
      return (passwordConfirm.trim() == password.trim());
    }
    return false;
  }

  _showToast(String message) {
    setState(() {
      _isLoading = false;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
