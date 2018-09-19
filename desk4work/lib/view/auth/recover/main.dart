import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/auth/recover/email_sent.dart';
import 'package:desk4work/view/common/orange_gradient.dart';
import 'package:flutter/material.dart';

class RecoverMainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RecoverMainScreenState();

}

class RecoverMainScreenState extends State<RecoverMainScreen>{
  var _formKey = GlobalKey<FormState>();
  var _scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _emailOrPhoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize  = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double formFieldPaddingVert = (screenHeight * .0195).toDouble();
    double formFieldPaddingHor = (screenWidth * .0667).toDouble();

    TextStyle textStyle = Theme.of(context).textTheme.subhead.copyWith(color: Colors.white);
    return Scaffold(
      body: Container(
        decoration: OrangeGradient.getGradient(),
        padding: EdgeInsets.only(top: (screenHeight * .0615).toDouble()),
        width: screenWidth,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              BackButton(color: Colors.white,)
            ],),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .0989).toDouble()),),
            Image.asset('assets/logo_horizontal.png',width: (screenWidth * .5573),
              height: (screenHeight * .1079),
              fit: BoxFit.fill,),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .081).toDouble()),),
            Container(
              width: (screenWidth * .84).toDouble(),
              child: Center(
                child: Text((StringResources.of(context).tEmailOrPhonePrompt),
                  textAlign: TextAlign.center,
                  style: textStyle),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .0345).toDouble()),),
            Container(
              width: (screenWidth * .84).toDouble(),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: _emailOrPhoneController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: formFieldPaddingVert, horizontal: formFieldPaddingHor),
                    hintText: StringResources.of(context).hEmailOrPhone),
                validator: (emailOrPhone) {
                  if (emailOrPhone.isEmpty)
                    return StringResources.of(context).eEmptyEmailOrPhone;
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .0435).toDouble()),),
            Container(
                width: (screenWidth * .84).toDouble(),
                height: (screenHeight * .0825).toDouble(),
                decoration:  BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(28.0))),
                child: Center(
                  child: InkWell(
                    child: Text(
                      StringResources.of(context).bRecover,
                      style: TextStyle(color: Colors.orange),
                    ),
                    onTap: () {
                      if (_formKey.currentState.validate()) _sendForm();
                    },
                  ),
                ))
                ],
              ),
            ),
    );
  }

  _sendForm(){
    String emailOrPhone = _emailOrPhoneController.text;
  }

}