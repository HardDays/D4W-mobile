import 'dart:async';

import 'package:desk4work/view/main/payment_method.dart';
import 'package:desk4work/view/main/history_list.dart';
import 'package:desk4work/view/main/payment.dart';
import 'package:desk4work/view/main/profile_edit.dart';
import 'package:desk4work/api/users_api.dart';
import 'package:desk4work/model/user.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileMenuScreen extends StatefulWidget {
  final bool isSocialLogin;

  ProfileMenuScreen(this.isSocialLogin);

  @override
  State<StatefulWidget> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
  StringResources _stringResources;
  Size _screenSize;

  UsersApi _usersApi = UsersApi();
  double _screenHeight, _screenWidth;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            _stringResources.tPrivateKabinet,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[]),
      body: _buildProfilePage(),
    );
  }

  FutureBuilder<User> _buildProfilePage() {
    return FutureBuilder<User>(
        future: _getMe(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _showMessage(_stringResources.mNoInternet);
            case ConnectionState.waiting:
              return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50.0),
                  child: new CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("error  loading booking ${snapshot.error}");
                return _showMessage(_stringResources.mServerError);
              } else {
                if (snapshot.data == null)
                  return _showMessage(_stringResources.mServerError);
                else {
                  return _getUserProfile(snapshot.data);
                }
              }
              break;
            case ConnectionState.active:
              break;
          }
        });
  }

  Future<User> _getMe() {
    return SharedPreferences.getInstance().then((sp) {
      String token = sp.getString(ConstantsManager.TOKEN_KEY);
      if(token !=null){
        return _usersApi.getMe(token).then((user) {
          return user;
        }).catchError((error){
          print('get me front error: $error');
          return null;
        });
      }else return null;
    });
  }

  Widget _getUserProfile(User user) {
    return Container(
      color: Color(0xFFE5E5E5),
      child: Column(
        children: <Widget>[
          Container(
              height: _screenHeight * 0.17,
              width: _screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withAlpha(100))),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(user, socialLogin: widget.isSocialLogin,)));
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          top: _screenHeight * 0.02,
                          bottom: _screenHeight * 0.02,
                          left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: _screenHeight * 0.17 - 40.0,
                                    height: _screenHeight * 0.17 - 40.0,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100.0)),
                                        child: user.imageId != null
                                            ? CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Icon(
                                                      Icons.person,
                                                      size:
                                                          _screenHeight * 0.15 -
                                                              40.0,
                                                      color: Colors.grey,
                                                    )),
                                                errorWidget: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Icon(
                                                      Icons.person,
                                                      size:
                                                          _screenHeight * 0.15 -
                                                              40.0,
                                                      color: Colors.grey,
                                                    )),
                                                imageUrl: ConstantsManager
                                                        .IMAGE_BASE_URL +
                                                    "${user.imageId}")
                                            : Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Icon(
                                                  Icons.person,
                                                  size: _screenHeight * 0.15 -
                                                      40.0,
                                                  color: Colors.grey,
                                                )))),
                                Container(
                                    width: _screenWidth -
                                        (_screenHeight * 0.17 + 50),
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.firstName != null &&
                                                  user.lastName != null
                                              ? '${user.firstName} ${user.lastName}'
                                              : _stringResources.tProfile,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0),
                                        ),
                                        Text(
                                          user.email ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 14.0),
                                        ),
                                        Text(
                                          user.phone ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 14.0),
                                        )
                                      ],
                                    )),
                              ]),
                          IconButton(
                              iconSize: 16.0,
                              icon: Icon(Icons.arrow_forward_ios))
                        ],
                      )))),
          Container(
              margin: EdgeInsets.only(top: 7.0),
              width: _screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withAlpha(100))),
              child: Column(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryListScreen()));
                  },
                  child: Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/history.png')))),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  width: _screenWidth - 120,
                                  child: Text(
                                    _stringResources.tHistory,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ]),
                          IconButton(
                              iconSize: 16.0,
                              icon: Icon(Icons.arrow_forward_ios))
                        ],
                      )),
                ),
                Divider(height: 2.0),
                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/credit_card.png')))),
                              Container(
                                margin: EdgeInsets.only(left: 20.0),
                                width: _screenWidth - 120,
                                child: Text(
                                  _stringResources.tPaymentOption,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontSize: 16.0),
                                ),
                              ),
                            ]),
                        IconButton(
                          iconSize: 16.0,
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
//                                builder: (ctx) => Payment()));
                                builder: (ctx) => PaymentMethod()));
                          },
                        )
                      ],
                    )),
//                Divider(height: 2.0),
//                Container(
//                  padding: EdgeInsets.only(left: 20.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget> [
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget> [
//                          Container(
//                            width: 20.0,
//                            height: 20.0,
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                image: AssetImage('assets/question.png')
//                              )
//                            )
//                          ),
//                          Container(
//                            margin: EdgeInsets.only(left: 20.0),
//                            width: _screenWidth - 120,
//                            child: Text(_stringResources.tHelp,
//                              style: TextStyle(
//                                fontWeight: FontWeight.w300,
//                                color: Colors.black,
//                                fontSize: 16.0
//                              ),
//                            ),
//                          ),
//                        ]
//                      ),
//                      IconButton(
//                        iconSize: 16.0,
//                        icon: Icon(Icons.arrow_forward_ios)
//                      )
//                    ],
//                  )
//                )
              ])),
        ],
      ),
    );
  }

  Widget _showMessage(String message) {
    return Center(
      child: Text(message,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
    );
  }
}
