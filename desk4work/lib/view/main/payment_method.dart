import 'dart:io';

import 'package:desk4work/utils/string_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethod extends StatefulWidget {
  final String _secretKey = 'sk_test_e761fd68f0ca88d9b1c1e95707a47e818f18cc59';
  final String _publicKey = 'pk_test_92503ad13564b7f601e84f1cae0d639fd5bfe838';
  static const String PAYMENT_OPTION_KEY = "paymentOption";
  static const int CASH_OPTION = 2;
  static const int CARD_OPTION = 1;


  @override
  State<StatefulWidget> createState() => _PaymentMethodState();
}
enum PaymentOption {Card, Cash, Undefined}

class _PaymentMethodState extends State<PaymentMethod> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
//  static const int GOOGLE_PAY_OPTION = 3;

  PaymentOption _paymentOption = PaymentOption.Undefined;
  StringResources _stringResources;
  SharedPreferences _sp;
  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  CheckoutMethod _method;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      SharedPreferences.getInstance().then((_){
        _sp = _;
        int paymentOption = _sp.getInt(PaymentMethod.PAYMENT_OPTION_KEY);
        if(paymentOption == PaymentMethod.CARD_OPTION) {
          setState(() {
            _paymentOption = PaymentOption.Card;
          });
        }
        else if(paymentOption == PaymentMethod.CASH_OPTION) {
          setState(() {
            _paymentOption = PaymentOption.Cash;
          });

        }
        else{
          setState(() {
            _paymentOption = PaymentOption.Undefined;
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _stringResources = StringResources.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text(_stringResources.tPayment, style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
//        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: 32.0,
                  padding: EdgeInsets.only(left: 24.0, top: 12.0),
                  child: Text(_stringResources.tPaymentMethods, style: TextStyle(color: Colors.black45),),

                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      RadioListTile<PaymentOption>(
                        title: Text(_stringResources.tPayByCard),
                        value: PaymentOption.Card,
                        groupValue: _paymentOption,
                        onChanged: _handleRadioValueChanged,
                      ),
                      Divider(),
                      RadioListTile<PaymentOption>(
                        title: Text(_stringResources.tPayByCash),
                        value: PaymentOption.Cash,
                        groupValue: _paymentOption,
                        onChanged: _handleRadioValueChanged,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChanged(PaymentOption value) {
    print("changin value $value");
    setState(() => _paymentOption = value);
    if(_sp !=null){
      if(value == PaymentOption.Cash)
      _sp.setInt(PaymentMethod.PAYMENT_OPTION_KEY, PaymentMethod.CASH_OPTION);
      else if(value == PaymentOption.Card)
        _sp.setInt(PaymentMethod.PAYMENT_OPTION_KEY, PaymentMethod.CARD_OPTION);

    }else{
      SharedPreferences.getInstance().then((_){
        _sp = _;
        _handleRadioValueChanged(value);
      }
      );
    }
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  handleOnSuccess(Transaction transaction) {
    _showMessage('transaction succesfull ${transaction.reference}');
  }
}

int _toInt(String source) {
  int value;
  try {
    return int.parse(source);
  } catch (e) {
    print('Error occured while parsing $value to int. Error: $e');
  }
  return value;
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}
