import 'package:desk4work/utils/string_resources.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RegistrationScreenState();

}

class RegistrationScreenState extends State<RegistrationScreen>{
  var _formKey = GlobalKey<FormState>();
  Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: (_screenSize.height * .078).toDouble()),
        width: (_screenSize.width * .84).toDouble(),
        height: (_screenSize.height * .7).toDouble(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo_horizontal_color_shaded.png',
              fit: BoxFit.fill,
              width:(_screenSize.width * .4311).toDouble() ,
              height: (_screenSize.height * .0836).toDouble(),
            ),
            Container(
              margin: EdgeInsets.only(top: (_screenSize.height * .0633).toDouble()),

            ),
            _getSendFormButton()

          ],
        ),
      ),
    );
  }
  Widget _getForm(){

  }

  Widget _getSendFormButton(){
    return Container(
        margin: EdgeInsets.only(top: (_screenSize.height * .0405).toDouble()),
        width: (_screenSize.width * .84).toDouble(),
        height: (_screenSize.height * .0825).toDouble(),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(28.0))),
        child: Center(
          child: InkWell(
            child: Text(
              StringResources.of(context).bRegister,
              style: TextStyle(color: Colors.orange),
            ),
            onTap: () {
              if (_formKey.currentState.validate()) _sendForm();
            },
          ),
        ));
  }

  _sendForm(){

  }

}