import 'package:flutter/material.dart';

class StringResources {
  final Locale locale;

  static final String _buttonEnter = 'buttonEnter';
  static final String _buttonContinue = 'buttonContinue';
  static final String _buttonRecover = 'buttonRecover';
  static final String _buttonRegister = 'buttonRegister';

  static final String _hintLogin = 'hintLogin';
  static final String _hintPassword = 'hintPassword';
  static final String _hintPasswordConfirm = 'hintPasswordConfirm';
  static final String _hintEmail = 'hintEmail';
  static final String _hintPhone = 'hintPhone';


  static final String _textForgotPassword = 'textForgotPassword';
  static final String _textSocialLogin = 'textSocialLogin';

  static final String _errorEmptyLogin = 'errorEmptyLogin';
  static final String _errorEmptyPassword = 'errorEmptyPassword';
  static final String _errorEmptyPasswordConfirm = 'errorEmptyPasswordConfirm';
  static final String _errorNotMatchingPasswords = 'errorMatchingPasswords';
  static final String _errorEmptyPhone = 'errorEmptyPhone';
  static final String _errorEmptyEmail = 'errorEmptyEmail';



  StringResources(this.locale);

  static StringResources of(BuildContext context){
    return Localizations.of<StringResources>(context, StringResources);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      _buttonEnter: 'ENTER',
      _buttonContinue: 'CONTINUE',
      _buttonRecover: 'RECOVER',
      _buttonRegister: 'REGISTER',
      _hintLogin: 'Login',
      _hintPassword: 'Password',
      _hintPasswordConfirm: 'Confirm password',
      _hintPhone: 'Phone',
      _hintEmail: 'Email',
      _textForgotPassword: 'Forgot password ?',
      _textSocialLogin : 'Log in through social networks',
      _errorEmptyLogin : 'Login can\'t be empty',
      _errorEmptyPassword: 'Password can\'t be empty',
      _errorEmptyPasswordConfirm: 'This field can\'t be empty',
      _errorNotMatchingPasswords: 'Passwords don\'t match, please try again',
      _errorEmptyPhone: 'This field can\'t be empty',
      _errorEmptyEmail: 'This field can\'t be empty',
    },
    'ru': {
      _buttonEnter: 'ВОЙТИ',
      _buttonContinue: 'ПРОДОЛЖИТЬ',
      _buttonRecover: 'ВОССТАНОВИТЬ',
      _buttonRegister: 'ЗАРЕГИСТРИРОВАТЬСЯ',
      _hintLogin: 'Логин',
      _hintPassword: 'Пароль',
      _hintPasswordConfirm: 'Подтвердите пароль',
      _hintPhone: 'Телефон',
      _hintEmail: 'Email',
      _textForgotPassword: 'Забыли пароль ?',
      _textSocialLogin : 'Войти через соц.сети',
      _errorEmptyLogin : 'Логин не может быть пустым',
      _errorEmptyPassword: 'Пароль не может быть пустым',
      _errorEmptyPasswordConfirm: '\'Подтврерждение пароль\' не может быть пустым',
      _errorNotMatchingPasswords: 'Пароли не соответствуют, проверте пожалуйста',
      _errorEmptyPhone: 'Телефон не может быть пустым',
      _errorEmptyEmail: 'Email не может быть пустым',
    }
  };

  String get bEnter {
    return _localizedValues[locale.languageCode][_buttonEnter];
  }

  String get bContinue {
    return _localizedValues[locale.languageCode][_buttonContinue];
  }

  String get bRecover {
    return _localizedValues[locale.languageCode][_buttonRecover];

  }
  String get bRegister {
    return _localizedValues[locale.languageCode][_buttonRegister];
  }

  String get tForgotPassword {
    return _localizedValues[locale.languageCode][_textForgotPassword];
  }

  String get tSocialLogin  {
    return _localizedValues[locale.languageCode][_textSocialLogin];
  }

  String get eEmptyLogin {
    return _localizedValues[locale.languageCode][_errorEmptyLogin];
  }

  String get eEmptyPassword {
    return _localizedValues[locale.languageCode][_errorEmptyPassword];
  }

  String get eEmptyPasswordConfirm {
    return _localizedValues[locale.languageCode][_errorEmptyPasswordConfirm];
  }

  String get eEmptyPhone {
    return _localizedValues[locale.languageCode][_errorEmptyPhone];
  }

  String get eEmptyEmail {
    return _localizedValues[locale.languageCode][_errorEmptyEmail];
  }

  String get eNotMatchingPasswords =>
      _localizedValues[locale.languageCode][_errorNotMatchingPasswords];


  String get hLogin {
    return _localizedValues[locale.languageCode][_hintLogin];
  }

  String get hPassword {
    return _localizedValues[locale.languageCode][_hintPassword];
  }


  String get hPasswordConfirm {
    return _localizedValues[locale.languageCode][_hintPasswordConfirm];
  }

  String get hEmail {
    return _localizedValues[locale.languageCode][_hintEmail];
  }

  String get hPhone {
    return _localizedValues[locale.languageCode][_hintPhone];
  }


}