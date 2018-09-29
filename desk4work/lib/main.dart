import 'package:desk4work/routes.dart';
import 'package:desk4work/utils/custom_localizations_delegate.dart';
import 'package:desk4work/view/auth/login.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:desk4work/view/filter/filter_root.dart';
import 'package:desk4work/view/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:desk4work/utils/constants.dart';




void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_){
        runApp(
            new MyApp());
      }
      );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DESK4WORK',
      theme: new ThemeData(
        backgroundColor: Colors.white,
        hintColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        const CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ru', 'RU')
      ],
      routes: routes,
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin<MyHomePage>{

  double _logoWidth, _logoHeight;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _logoHeight = (size.height * .2970).toDouble();
    _logoWidth = (size.width * .32701).toDouble();

    return Scaffold(
      body: Container(
        decoration: BoxDecorationUtil.getOrangeGradient(),
        child: Center(
          child: Image.asset('assets/logo_vertical.png',height:  _logoHeight, width: _logoWidth,),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SharedPreferences.getInstance().then((sp){
      if(sp.getString(ConstantsManager.TOKEN_KEY) == null)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>LoginScreen()));
      else
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MainScreen()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>FilterRoot()));
    });
  }


}
