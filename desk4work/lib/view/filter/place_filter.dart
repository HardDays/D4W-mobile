import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceFilterScreen extends StatefulWidget {
  final String _place;
  static const String KAZAN = 'Казань';
  static const String MOSCOW = 'Москва';
  static const String YEKATERINBURG  = 'Екатеринбург';
  static const String SAINT_PETERSBURG = 'Санкт-Петербург';


  PlaceFilterScreen(this._place);

  @override
  State<StatefulWidget> createState() => PlaceFilterScreenState();
}

class PlaceFilterScreenState extends State<PlaceFilterScreen> {
//  FilterStateContainerState containerFilterState;
//  Filter filter;
  StringResources _stringResources;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  String _tempSelection;
  String _place;

  List<String> _recents;
  final String RECENT_KEY = "recents";

  @override
  void initState() {
    _place = widget._place;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      SharedPreferences.getInstance().then((sp){
          _recents = sp.getStringList(RECENT_KEY);
        if(_recents !=null && _recents.isNotEmpty){
          _recents = _recents;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    containerFilterState = FilterStateContainer.of(context);
//    filter = containerFilterState.filter;
    _stringResources = StringResources.of(context);
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    final double textFilterParameterHeight = (_screenHeight * .0599);
    final double textFilterParameterWidth = (_screenWidth * .43);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Title(color: Colors.white, child: Text(_stringResources.tFilter, style: TextStyle(color: Colors.white),)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check, color: Colors.white,),
              onPressed: () {
                _validate();
              })
        ],
      ),
              body: Container(
          color: Colors.white,
//        decoration: BoxDecorationUtil.getDarkOrangeGradient(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Container(
//            decoration: BoxDecorationUtil.getDarkOrangeGradient(),
////            margin: EdgeInsets.only(
////              top: (_screenHeight * .0615).toDouble(),
////            ),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                BackButton(),
//                Text(_stringResources.tFilter),
//                IconButton(
//                    icon: Icon(Icons.check),
//                    onPressed: () {
//                      _validate();
//                    }),
//              ],
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(top: (_screenHeight * .002)),
//          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (_screenWidth * .048).toDouble()),
            child: Column(
              children: <Widget>[
//                  Container(
//                    height: textFilterParameterHeight,
//                    padding: EdgeInsets.only(left: 8.0),
//                    decoration:
//                        BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
//                    child: Row(
//                      children: <Widget>[
//                        Icon(Icons.place),
//                        Padding(
//                          padding: EdgeInsets.only(left: 8.0),
//                        ),
//                        Text((_place ??
//                            _tempSelection ??
//                            _stringResources.hPlace))
//                      ],
//                    ),
//                  ),
                Padding(
                  padding: EdgeInsets.only(top: (_screenHeight * .042)),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.black12, width: .5),
                    bottom: BorderSide(color: Colors.black12, width: .5),
                  )),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.orangeAccent,
                                    child: Row(
                                      children: <Widget>[
                                        _getText(_stringResources.tWherever,),
                                      ],
                                    ),
                                  onTap: (){
                                      _choosePlace(_stringResources.tWherever);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0507).toDouble()),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: .5))),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    splashColor: Colors.orangeAccent,
                                    onTap: () {
                                      _choosePlace(_stringResources.tNearby);
                                    },
                                    child: _getText(_stringResources.tNearby)),
                              ),
                            ),
                          ],
                        ),

                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0567).toDouble()),
                      )
                    ],
                  ),
                ),
                Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: .5))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.orangeAccent,
                                  child: Row(
                                    children: <Widget>[
                                      _getText(
                                        PlaceFilterScreen.KAZAN,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _choosePlace(PlaceFilterScreen.KAZAN);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0567).toDouble()),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: .5))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.orangeAccent,
                                  child: _getText(
                                    PlaceFilterScreen.MOSCOW,
                                  ),
                                  onTap: () {
                                    _choosePlace(PlaceFilterScreen.MOSCOW);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0567).toDouble()),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: .5))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.orangeAccent,
                                  child: _getText(
                                    PlaceFilterScreen.YEKATERINBURG,
                                  ),
                                  onTap: () {
                                    _choosePlace(PlaceFilterScreen.YEKATERINBURG);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0567).toDouble()),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: .5))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.orangeAccent,
                                  child: Container(
                                    child: _getText(
                                      PlaceFilterScreen.SAINT_PETERSBURG,
                                    ),
                                  ),
                                  onTap: () {
                                    _choosePlace(PlaceFilterScreen.SAINT_PETERSBURG);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: (_screenHeight * .0225).toDouble(),
                            horizontal: (_screenWidth * .0567).toDouble()),
                      ),
                    ],
                  ),
                ),
                Container(
//                  child: Column(
//                    children:_buildRecentWidgets(),
//                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildRecentWidgets(){
    if(_recents!=null && _recents.isNotEmpty){
      print('_recents $_recents');
      List<Widget> recent  = _recents.where((s)=> s!=null).map<Widget>((s){return _buildRecentWidget(s);}).toList();
      print('recent $recent');

    recent.add(Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.white, width: .5))),
      padding: EdgeInsets.only(
          top: (_screenHeight * .057).toDouble(),
          bottom: (_screenHeight * .015).toDouble(),
          left: (_screenWidth * .0567).toDouble()),
      child: Row(
        children: <Widget>[
          Text(
            _stringResources.tRecent,
            style: TextStyle(color: Colors.white70),
          ),

        ],
      ),
    ));
//    recent = recent.reversed.toList();
    return recent;}
    else return <Widget>[Container()];
  }


  TextStyle _getTextStyle(String place){
    return TextStyle(color: (_place == place || _tempSelection == place)? Colors.orangeAccent : Colors.black);
  }

  Text _getText(String place){
    return Text(place, style: _getTextStyle(place));
  }

  Widget _buildRecentWidget(String place){
    print('choosing place: $place');
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){ _choosePlace(place);},
              child: Row(children: <Widget>[
                Icon(Icons.place, color: (place == place || place == _tempSelection) ? Colors.orangeAccent : Colors.grey,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16.0)),
                Text(place, style: TextStyle(color: (_place == place || _tempSelection == place) ? Colors.orangeAccent : Colors.black),)

              ],),
            ),
          ),
        ),
      ],
    );
  }

  void _choosePlace(String place) {
    setState(() {
      _place = place;
      _tempSelection = place;
    });
  }

  void _validate() {
    SharedPreferences.getInstance().then((sp){
      if(_recents == null )
        _recents = List<String>();
      if(!_recents.contains(_tempSelection)){
        _recents.add(_tempSelection);
      }
      sp.setStringList(RECENT_KEY, _recents).then((_){
        Navigator.pop(context, _tempSelection);

      });
    });
//    if(_tempSelection !=null)
//      containerFilterState.updateFilterInfo(latLong: _tempSelection);
  }

  void _goBack() {
    Navigator.pop(context);
  }
}
