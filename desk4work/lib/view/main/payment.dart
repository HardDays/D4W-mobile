import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Payment extends StatefulWidget{
  static const String AMOUNT_EXTRA = "amount";
  static const String CO_WORKING_NAME = "coWorkingName";
  @override
  State<StatefulWidget> createState()=>_PaymentState();
}
class _PaymentState extends State<Payment>{
  static const platform = const MethodChannel('desk4Work/payment');


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _launchPayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<void> _launchPayment() async{
    String payment;
    try{
      await platform.invokeMethod('startPaymentProcess');

    }on PlatformException catch(e){
      print("error processing to payment: $e");
    }catch(e){
      print("error processing to payment: $e");
    }
  }
}