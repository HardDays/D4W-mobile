import 'dart:async';

import 'package:desk4work/api/users_api.dart';
import 'package:desk4work/utils/string_resources.dart'; 
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/view/common/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {

  ChangePasswordScreen(){
  }

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources _stringResources;
  UsersApi _usersApi;
  Size _screenSize;

  FocusNode _oldFocus;
  FocusNode _newFocus;
  FocusNode _newConfirmFocus;

  String _oldPassword;
  String _newPasssword;
  String _newPassswordConfirm;

  double _screenHeight, _screenWidth;

  @override
  void initState(){
    super.initState();
    
    _oldFocus = FocusNode();
    _newFocus = FocusNode();
    _newConfirmFocus = FocusNode();

    _usersApi = UsersApi();
  }

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text(
          _stringResources.tChangePassword,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              _onChangePassword();
            },
          )
        ]
      ),
      body: _buildPassPage(),
    );
  }

  void _onChangePassword(){
    if (_checkInput()){
      Dialogs.showLoader(context);
      SharedPreferences.getInstance().then((sp){
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        return _usersApi.changePassword(token, _oldPassword, _newPasssword, _newPassswordConfirm).then((res){
          _onUpdate(res);
        });
      });
    }
  }

  void _onUpdate(bool res){
    Navigator.pop(context);
    if (res){
      Dialogs.showMessage(context, _stringResources.tSuccess, _stringResources.tPasswordChanged, _stringResources.tOk);
    }else{
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.tWrongOldPassword, _stringResources.tOk);
    }
  }

  bool _checkInput(){
    if (_oldPassword == null || _newPasssword == null || _newPassswordConfirm == null || _newPasssword.length < 7 || _newPassswordConfirm.length < 7){
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.eEmptyPassword, _stringResources.tOk);
      return false;
    } else if (_newPasssword != _newPassswordConfirm){
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.eNotMatchingPasswords, _stringResources.tOk);
      return false;
    }
    return true;
  }
  
  Widget _buildPassPage(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Container(
                width: _screenWidth,
                margin: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.grey.withAlpha(200),
                        hintColor: Colors.grey.withAlpha(200)
                      ),
                      child: TextField(
                        autofocus: true,
                        focusNode: _oldFocus,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: _stringResources.hOldPassword,
                          contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                        ),
                        onChanged: (val){
                          setState(() {
                            _oldPassword = val;
                          });
                        }, 
                        onSubmitted: (val){
                          FocusScope.of(context).requestFocus(_newFocus);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25.0)),
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.grey.withAlpha(200),
                        hintColor: Colors.grey.withAlpha(200)
                      ),
                      child: TextField(
                        focusNode: _newFocus,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: _stringResources.hPassword,
                          contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                        ),
                        onChanged: (val){
                          setState(() {
                            _newPasssword = val;
                          });
                        },
                        onSubmitted: (val){
                          FocusScope.of(context).requestFocus(_newConfirmFocus);
                        },
                      ),
                    ),
                     Padding(padding: EdgeInsets.only(top: 25.0)),
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.grey.withAlpha(200),
                        hintColor: Colors.grey.withAlpha(200)
                      ),
                      child: TextField(
                        focusNode: _newConfirmFocus,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: _stringResources.hPasswordConfirm,
                          contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                        ),
                        onChanged: (val){
                          setState(() {
                            _newPassswordConfirm = val;
                          });
                        } 
                      ),
                    ),
                  ],
                )
              ),
            )
          )
        ]   
      ),
    );
  }
}
