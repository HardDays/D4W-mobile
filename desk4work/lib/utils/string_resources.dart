import 'package:flutter/material.dart';

class StringResources {
  final Locale locale;

  static final String _buttonEnter = 'buttonEnter';
  static final String _buttonContinue = 'buttonContinue';
  static final String _buttonRecover = 'buttonRecover';
  static final String _buttonRegister = 'buttonRegister';

  static final String _hintLogin = 'hintLogin';
  static final String _hintPassword = 'hintPassword';

  static final String _textForgotPassword = 'textForgotPassword';
  static final String _textSocialLogin = 'textSocialLogin';

  static final String _errorEmptyLogin = 'errorEmptyLogin';
  static final String _errorEmptyPassword = 'errorEmptypassword';



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
      _textForgotPassword: 'Forgot password ?',
      _textSocialLogin : 'Log in through social networks',
      _errorEmptyLogin : 'Login can\'t be empty',
      _errorEmptyPassword: 'Password can\'t be empty'
    },
    'ru': {
      _buttonEnter: 'ВОЙТИ',
      _buttonContinue: 'ПРОДОЛЖИТЬ',
      _buttonRecover: 'ВОССТАНОВИТЬ',
      _buttonRegister: 'ЗАРЕГИСТРИРОВАТЬСЯ',
      _hintLogin: 'Логин',
      _hintPassword: 'Пароль',
      _textForgotPassword: 'Забыли пароль ?',
      _textSocialLogin : 'Войти через соц.сети',
      _errorEmptyLogin : 'Логин не может быть пустым',
      _errorEmptyPassword: 'Пароль не может быть пустым'
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

  String get hLogin {
    return _localizedValues[locale.languageCode][_hintLogin];
  }

  String get hPassword {
    return _localizedValues[locale.languageCode][_hintPassword];
  }

  String get eEmptyLogin {
    return _localizedValues[locale.languageCode][_errorEmptyLogin];
  }

  String get eEmptyPassword {
    _localizedValues[locale.languageCode][_errorEmptyPassword];
  }


}