import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/common/theme_util.dart';
import 'package:flutter/material.dart';

class PlaceFilterScreen extends StatefulWidget {
  final String _place;

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


  @override
  void initState() {
    _place = widget._place;
    super.initState();
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

    return Theme(
      data: ThemeUtil.getThemeForOrangeBackground(context),
      child: Scaffold(
          body: Container(
        decoration: BoxDecorationUtil.getDarkOrangeGradient(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: (_screenHeight * .0615).toDouble(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BackButton(),
                  Text(_stringResources.tFilter),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _validate();
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: (_screenHeight * .029)),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (_screenWidth * .048).toDouble()),
              child: Column(
                children: <Widget>[
                  Container(
                    height: textFilterParameterHeight,
                    padding: EdgeInsets.only(left: 8.0),
                    decoration:
                        BoxDecorationUtil.getGreyRoundedCornerBoxDecoration(),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.place),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                        ),
                        Text((_place ??
                            _tempSelection ??
                            _stringResources.hPlace))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: (_screenHeight * .042)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Colors.white, width: .5),
                      bottom: BorderSide(color: Colors.white, width: .5),
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: InkWell(
                              child: Text(_stringResources.tWherever),
                            onTap: (){
                                _choosePlace(_stringResources.tWherever);
                            },
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: (_screenHeight * .0225).toDouble(),
                              horizontal: (_screenWidth * .0507).toDouble()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: .5))),
                        ),
                        Container(
                          child: InkWell(
                              onTap: () {
                                _choosePlace(_stringResources.tNearby);
                              },
                              child: Text(_stringResources.tNearby)),
                          padding: EdgeInsets.symmetric(
                              vertical: (_screenHeight * .0225).toDouble(),
                              horizontal: (_screenWidth * .0567).toDouble()),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
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
                                _stringResources.hPopular,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: .5))),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  'Казань',
                                ),
                                onTap: () {
                                  _choosePlace('Казань');
                                },
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
                                      color: Colors.white, width: .5))),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  'Москва',
                                ),
                                onTap: () {
                                  _choosePlace('Москва');
                                },
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
                                      color: Colors.white, width: .5))),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  'Екатеринбург',
                                ),
                                onTap: () {
                                  _choosePlace('Екатеринбург');
                                },
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
                                      color: Colors.white, width: .5))),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  'Санкт-Петербург',
                                ),
                                onTap: () {
                                  _choosePlace('Санкт-Петербург');
                                },
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: (_screenHeight * .0225).toDouble(),
                              horizontal: (_screenWidth * .0567).toDouble()),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _choosePlace(String place) {
    setState(() {
      _place = place;
      _tempSelection = place;
    });
  }

  void _validate() {
    Navigator.pop(context, _tempSelection);
//    if(_tempSelection !=null)
//      containerFilterState.updateFilterInfo(latLong: _tempSelection);
  }

  void _goBack() {
    Navigator.pop(context);
  }
}
