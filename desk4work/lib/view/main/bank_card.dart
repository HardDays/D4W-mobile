import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentPage extends StatefulWidget {
  final String _secretKey = 'sk_test_e761fd68f0ca88d9b1c1e95707a47e818f18cc59';
  final String _publicKey = 'pk_test_92503ad13564b7f601e84f1cae0d639fd5bfe838';

  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  @override
  void initState() {
    PaystackPlugin.initialize(
        publicKey: widget._publicKey, secretKey: widget._secretKey);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: const Text('Initalize transaction from:'),
                    ),
                    new Expanded(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new RadioListTile<int>(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: const Text('Local'),
                            ),
                            new RadioListTile<int>(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: const Text('Server'),
                            ),
                          ]),
                    )
                  ],
                ),
                _border,
                _verticalSizeBox,
                new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Card number',
                  ),
                  onSaved: (String value) => _cardNumber = value,
                ),
                _verticalSizeBox,
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'CVV',
                        ),
                        onSaved: (String value) => _cvv = value,
                      ),
                    ),
                    _horizontalSizeBox,
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Month',
                        ),
                        onSaved: (String value) => _expiryMonth = _toInt(value),
                      ),
                    ),
                    _horizontalSizeBox,
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Year',
                        ),
                        onSaved: (String value) => _expiryYear = _toInt(value),
                      ),
                    )
                  ],
                ),
                _verticalSizeBox,
                _inProgress
                    ? new Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Platform.isIOS
                      ? new CupertinoActivityIndicator()
                      : new CircularProgressIndicator(),
                )
                    : new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getPlatformButton(
                        'Charge Card', () => _startAfreshCharge()),
                    _verticalSizeBox,
                    _border,
                    new SizedBox(
                      height: 40.0,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                            flex: 3,
                            child: new DropdownButtonHideUnderline(
                                child: new InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    hintText: 'Checkout method',
                                  ),
                                  isEmpty: _method == null,
                                  child: new DropdownButton<CheckoutMethod>(
                                    value: _method,
                                    isDense: true,
                                    onChanged: (CheckoutMethod value) {
                                      setState(() {
                                        _method = value;
                                      });
                                    },
                                    items: banks.map((String value) {
                                      return new DropdownMenuItem<
                                          CheckoutMethod>(
                                        value: _parseStringToMethod(value),
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ))),
                        _horizontalSizeBox,
                        new Flexible(
                          flex: 2,
                          child: new Container(
                              width: double.infinity,
                              child: _getPlatformButton(
                                'Checkout',
                                    () => _handleCheckout(),
                              )),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _handleRadioValueChanged(int value) =>
      setState(() => _radioValue = value);

  _handleCheckout() async {
    if (_method == null) {
      _showMessage('Select checkout method first');
      return;
    }
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = 10000
      ..email = 'customer@email.com'
      ..card = _getCardFromUI();

    if (_method != CheckoutMethod.bank) {
      if (!_isLocal()) {
//        var accessCode = await _fetchAccessCodeFrmServer(_getReference());
//        charge.accessCode = accessCode;
      print('print transaction not local');
      } else {
        print('Using reference');
        charge.reference = _getReference();
      }
    }

    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: _method,
      charge: charge,
    );
    print('Response = $response');
    setState(() => _inProgress = false);
    _updateStatus(response.reference, '$response');
  }

  _startAfreshCharge() async {
    _formKey.currentState.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

    if (_isLocal()) {
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception
      // 1 NGN = 100Kobo
      // x NGN  = 2000
      charge
        ..amount = 10000
        ..email = 'customer@email.com'
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Flutter SDK');
      _chargeCard(charge);
    } else {
      // Perform transaction/initialize on Paystack server to get an access code
      // documentation: https://developers.paystack.co/reference#initialize-a-transaction
//      charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
//      _chargeCard(charge);
    print(' transaction is not local');
    }
  }

  _chargeCard(Charge charge) {
    // This is called only before requesting OTP
    // Save reference so you may send to server if error occurs with OTP
    handleBeforeValidate(Transaction transaction) {
      _updateStatus(transaction.reference, 'validating...');
    }

    handleOnError(Object e, Transaction transaction) {
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      if (e is ExpiredAccessCodeException) {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }

      if (transaction.reference != null) {
        print('transaction not null');
        setState(() => _inProgress = false);

//        _verifyOnServer(transaction.reference);
      } else {
        setState(() => _inProgress = false);
        _updateStatus(transaction.reference, e.toString());
      }
    }



    PaystackPlugin.chargeCard(context,
        charge: charge,
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        onSuccess: (transaction) => handleOnSuccess(transaction),
        onError: (error, transaction) => handleOnError(error, transaction));
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );

    // Using Cascade notation (similar to Java's builder pattern)
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear)
//      ..name = 'Segun Chukwuma Adamu'
//      ..country = 'Nigeria'
//      ..addressLine1 = 'Ikeja, Lagos'
//      ..addressPostalCode = '100001';

    // Using optional parameters
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear,
//        name: 'Ismail Adebola Emeka',
//        addressCountry: 'Nigeria',
//        addressLine1: '90, Nnebisi Road, Asaba, Deleta State');
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;


      widget = new RaisedButton(
        onPressed: function,
        color: Colors.blueAccent,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );

    return widget;
  }





  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
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

  bool _isLocal() {
    return _radioValue == 0;
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