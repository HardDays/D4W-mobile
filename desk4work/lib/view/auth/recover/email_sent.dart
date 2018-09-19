import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/auth/login.dart';
import 'package:desk4work/view/common/orange_gradient.dart';
import 'package:flutter/material.dart';

class RecoverEmailSentScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Size screenSize  = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double formFieldPaddingVert = (screenHeight * .0195).toDouble();
    double formFieldPaddingHor = (screenWidth * .0667).toDouble();

    TextStyle textStyleSubHead = Theme.of(context).textTheme.subhead.copyWith(color: Colors.white);
    TextStyle textStyleTitle = Theme.of(context).textTheme.title.copyWith(color: Colors.white);
    return Scaffold(
      body: Container(
        decoration: OrangeGradient.getGradient(),
        padding: EdgeInsets.only(top: (screenHeight * .0615).toDouble()),
        width: screenWidth,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: (screenHeight * .1169).toDouble()),),
            Image.asset('assets/logo_horizontal.png',width: (screenWidth * .5573),
              height: (screenHeight * .1079),
              fit: BoxFit.fill,),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .1544).toDouble()),),
            Container(
              width: (screenWidth * .84).toDouble(),
              child: Center(
                child: Text((StringResources.of(context).tPromptEmailCheck),
                    textAlign: TextAlign.center,
                    style: textStyleTitle),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .0525).toDouble()),),
            Container(
              width: (screenWidth * .84).toDouble(),
              child: Center(
                child: Text((StringResources.of(context).tRecoveryEmailSent),
                    textAlign: TextAlign.center,
                    style: textStyleSubHead),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: (screenHeight * .0645).toDouble()),),
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
                      Navigator.of(context)
                          .pushReplacement(
                          MaterialPageRoute(builder: (ctx)=> LoginScreen()));
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }


}