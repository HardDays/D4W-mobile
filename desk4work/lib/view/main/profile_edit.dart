import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:desk4work/view/main/change_password.dart';
import 'package:desk4work/api/users_api.dart';
import 'package:desk4work/utils/string_resources.dart'; 
import 'package:desk4work/utils/constants.dart';
import 'package:desk4work/model/user.dart';
import 'package:desk4work/view/common/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class ProfileEditScreen extends StatefulWidget {

  User _user;

  ProfileEditScreen(User user){
    _user = user;
  }

  @override
  State<StatefulWidget> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditScreen> {
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources _stringResources;
  UsersApi _usersApi;
  Size _screenSize;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  FocusNode _emailFocus;
  FocusNode _phoneFocus;
  File _image;

  String _firstName;
  String _lastName;
  String _email;
  String _phone;

  double _screenHeight, _screenWidth;

  @override
  void initState(){
    super.initState();
    
    _usersApi = UsersApi();
    _firstNameController = TextEditingController(text: widget._user.firstName);
    _lastNameController = TextEditingController(text: widget._user.lastName);
    _emailController = TextEditingController(text: widget._user.email);
    _phoneController = TextEditingController(text: widget._user.phone);
    _firstName = widget._user.firstName;
    _lastName = widget._user.lastName;
    _email = widget._user.email;
    _phone = widget._user.phone;
    _emailFocus = FocusNode();
    _phoneFocus = FocusNode();
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
          _stringResources.tPrivateKabinet,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              _updateProfile();
            },
          )
        ]
      ),
      body: _buildProfilePage(),
    );
  }
  
  Widget _buildProfilePage(){
    return Container(
      color: Color(0xFFE5E5E5),
      child: Column(
        children: <Widget>[
          Container(
            height: _screenHeight * 0.19,
            width: _screenWidth,
            decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(
                 color: Colors.grey.withAlpha(100)
               )
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: _screenHeight * 0.02,
                  bottom: _screenHeight * 0.02, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          var res = await ImagePicker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            if (res != null){
                              _image = res;                                        
                            }
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: _screenHeight * 0.17 - 40.0,
                              height: _screenHeight * 0.17 - 40.0,
                              child: ClipRRect( 
                                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                child: _image == null ? 
                                  (widget._user.imageId != null ? 
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      placeholder: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey)
                                      ),
                                      child: Icon(Icons.person,
                                        size: _screenHeight * 0.15 - 40.0,
                                        color: Colors.grey,
                                      )
                                    ),
                                    errorWidget: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey)
                                      ),
                                      child: Icon(Icons.person,
                                        size: _screenHeight * 0.15 - 40.0,
                                        color: Colors.grey,
                                      )
                                    ),
                                    imageUrl: ConstantsManager.IMAGE_BASE_URL + "${widget._user.imageId}"                 
                                  ) :   
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey)
                                    ),
                                    child: Icon(Icons.person,
                                      size: _screenHeight * 0.15 - 40.0,
                                      color: Colors.grey,
                                    )
                                  )
                                ) : Container(
                                  child: Image(
                                    fit: BoxFit.cover,
                                    width: _screenHeight * 0.17 - 40.0,
                                    height: _screenHeight * 0.17 - 40.0,
                                    image: FileImage(_image)
                                  )
                                )
                              )
                            ), 
                            Container(
                              width: _screenHeight * 0.17 - 40.0,
                              height: _screenHeight * 0.17 - 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withAlpha(180)
                              ),
                              child: Icon(Icons.camera_alt,
                                size: _screenHeight * 0.1 - 40.0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: _screenWidth - (_screenHeight * 0.17 + 50),
                        margin: EdgeInsets.only(left: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Theme(
                              data: ThemeData(
                                primaryColor: Colors.grey.withAlpha(90),
                                hintColor: Colors.grey.withAlpha(90)
                              ),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  hintText: _stringResources.hFirstName,
                                  contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                                ),
                                controller: _firstNameController, 
                                onChanged: (val){
                                  setState(() {
                                    _firstName = val;                                    
                                  });
                                } 
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10.0)),
                            Theme(
                              data: ThemeData(
                                primaryColor: Colors.grey.withAlpha(90),
                                hintColor: Colors.grey.withAlpha(90)
                              ),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  hintText: _stringResources.hLastName,
                                  contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                                ),
                                controller: _lastNameController,  
                                onChanged: (val){
                                  setState(() {
                                    _lastName = val;                                    
                                  });
                                } 
                              ),
                            ),
                          ],
                        )
                      ),
                    ]
                  ),
                ],
              )
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 7.0),
            width: _screenWidth,
            decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(
                 color: Colors.grey.withAlpha(100)
               )
            ),
            child: Column(
              children: <Widget> [ 
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      GestureDetector(
                        onTap: (){
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        child: Container(
                          child: Text(_stringResources.tChangeEmail,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 16.0
                            ),
                          ),  
                        ),
                      ),
                      Container(
                        width: _screenWidth * 0.4,
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.grey.withAlpha(90),
                            hintColor: Colors.grey.withAlpha(0)
                          ),
                          child: TextField(
                            focusNode: _emailFocus,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black.withAlpha(180),
                              fontWeight: FontWeight.w300
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                            ),
                            controller: _emailController,  
                            onChanged: (val){
                              setState(() {
                                _email = val;                                    
                              });
                            } 
                          ),
                        ),
                      )
                    ]  
                  )          
                ),
                Divider(height: 2.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      GestureDetector(
                        onTap: (){
                          FocusScope.of(context).requestFocus(_phoneFocus);
                        },
                        child: Container(
                          child: Text(_stringResources.tChangePhone,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 16.0
                            ),
                          ),  
                        ),
                      ),
                      Container(
                        width: _screenWidth * 0.4,
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.grey.withAlpha(90),
                            hintColor: Colors.grey.withAlpha(0)
                          ),
                          child: TextField(
                            focusNode: _phoneFocus,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black.withAlpha(180),
                              fontWeight: FontWeight.w300
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 3.0, bottom: 4.0),
                            ),
                            controller: _phoneController,  
                            onChanged: (val){
                              setState(() {
                                _phone = val;                                    
                              });
                            } 
                          ),
                        ),
                      )
                    ]  
                  )          
                ),
              ]
            )
          ),
          Padding(padding: EdgeInsets.only(top: 7.0)),
          GestureDetector(
            onTap: (){ Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context)=> ChangePasswordScreen()));
            },
              child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 0.0),
                        width: _screenWidth - 120,
                        child: Text(_stringResources.tChangePassword,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 16.0
                          ),
                        ),  
                      ),
                    ]
                  ),
                  IconButton(
                    iconSize: 16.0,
                    icon: Icon(Icons.arrow_forward_ios)
                  )
                ],
              )
            )
          ),
          Padding(padding: EdgeInsets.only(top: 8.0)),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 14.0, bottom: 14.0),
                      alignment: Alignment.center,
                      width: _screenWidth,
                      child: Text(_stringResources.tLogout,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFFE0B05),
                          fontSize: 16.0
                        ),
                      ),  
                    ),
                  ]
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  void _updateProfile(){
    if (_validateInfo()){
      var user = User(firstName: _firstName, 
                      lastName: _lastName, 
                      email: _email, 
                      phone: _phone); 
      if (_image != null){
        user.image = base64Encode(_image.readAsBytesSync());
      }
      Dialogs.showLoader(context);
      SharedPreferences.getInstance().then((sp){
        String token = sp.getString(ConstantsManager.TOKEN_KEY);
        return _usersApi.updateMe(token, user).then((res){
          _onUpdate(res);
        });
      });
    }
  }

  bool _validateInfo(){
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.eWrongEmail, _stringResources.tOk);
      return false;
    } else if (_phone.isEmpty){
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.eEmptyPhone, _stringResources.tOk);
      return false;
    }
    return true;
  }

  void _onUpdate(User user){
    Navigator.pop(context);
    if (user != null){
      Dialogs.showMessage(context, _stringResources.tSuccess, _stringResources.tProfileChanged, _stringResources.tOk);
    }else{
      Dialogs.showMessage(context, _stringResources.tError, _stringResources.tTryAgain, _stringResources.tOk);
    }
  }
}
