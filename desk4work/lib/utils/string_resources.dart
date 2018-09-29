import 'package:flutter/material.dart';

class StringResources {
  final Locale locale;

  static final String _buttonEnter = 'buttonEnter';
  static final String _buttonContinue = 'buttonContinue';
  static final String _buttonRecover = 'buttonRecover';
  static final String _buttonRegister = 'buttonRegister';
  static final String _buttonConfirm = 'buttonConfirm';

  static final String _hintLogin = 'hintLogin';
  static final String _hintPassword = 'hintPassword';
  static final String _hintPasswordConfirm = 'hintPasswordConfirm';
  static final String _hintEmail = 'hintEmail';
  static final String _hintPhone = 'hintPhone';
  static final String _hintEmailOrPhone = 'hintEmailOrPhone';
  static final String _hintDateFilter = 'hintDateFilter';
  static final String _hintStartFilter = 'hintStartFilter';
  static final String _hintEndFilter = 'hintEndFilter';
  static final String _hintPlaceFilter = 'hintPlaceFilter';



  static final String _textForgotPassword = 'textForgotPassword';
  static final String _textSocialLogin = 'textSocialLogin';
  static final String _textHello = 'textHello';
  static final String _textSuccessfulRegisration = 'textSuccessfulRegistration';
  static final String _textEmailOrPhonePrompt = 'textEmailPromt';
  static final String _textEmailInboxCheckPrompt = 'textEmailInboxCheckPromt';
  static final String _textEmailSent = 'textEmailSent';
  static final String _textClearFilter = 'textClearFilter';
  static final String _textFilter = 'textFiltert';
  static final String _textPlace = 'textPlaceFilter';
  static final String _textComfort = 'textComfortFilter';
  static final String _textPrint = 'textPrintFilter';
  static final String _textTeaCoffee = 'textTeaCoffeeFilter';
  static final String _textConferenceRoom = 'textConferenceRoomFilter';
  static final String _textBycicleParkFilter = 'textBycicleFilter';
  static final String _textKitchen = 'textKitchen';


  static final String _errorEmptyLogin = 'errorEmptyLogin';
  static final String _errorEmptyPassword = 'errorEmptyPassword';
  static final String _errorEmptyPasswordConfirm = 'errorEmptyPasswordConfirm';
  static final String _errorNotMatchingPasswords = 'errorMatchingPasswords';
  static final String _errorEmptyPhone = 'errorEmptyPhone';
  static final String _errorEmptyEmail = 'errorEmptyEmail';
  static final String _errorEmptyEmailOrPhone = 'errorEmptyEmailOrPhone';




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
      _buttonConfirm: 'Confirm',
      _hintLogin: 'Login',
      _hintPassword: 'Password',
      _hintPasswordConfirm: 'Confirm password',
      _hintPhone: 'Phone',
      _hintEmail: 'Email',
      _hintEmailOrPhone: 'Email or phone',
      _hintPlaceFilter: 'Place',
      _hintDateFilter: 'Date',
      _hintStartFilter: 'Start',
      _hintEndFilter: 'end',
      _textForgotPassword: 'Forgot password ?',
      _textSocialLogin : 'Log in through social networks',
      _textEmailInboxCheckPrompt: 'CHECK YOUR MAILS',
      _textEmailSent: 'We have sent you an email with instructions to restore your password',
      _textEmailOrPhonePrompt: 'Enter the email or phone number for the accout you want to recover',
      _textSuccessfulRegisration: 'You have successfully registered and you can now start working with the app!',
      _textHello: 'Hello, ',
      _textClearFilter: 'Clear',
      _textFilter: 'Filter',
      _textPlace: 'Place',
      _textComfort: 'Comfort',
      _textPrint: 'Print',
      _textTeaCoffee: 'Tea/Coffee',
      _textConferenceRoom: 'Conference room',
      _textKitchen: 'Kitchen',
      _textBycicleParkFilter: 'Park for bicycle',
      _errorEmptyLogin : 'Login can\'t be empty',
      _errorEmptyPassword: 'Password can\'t be empty',
      _errorEmptyPasswordConfirm: 'This field can\'t be empty',
      _errorNotMatchingPasswords: 'Passwords don\'t match, please try again',
      _errorEmptyPhone: 'This field can\'t be empty',
      _errorEmptyEmail: 'This field can\'t be empty',
      _errorEmptyEmailOrPhone: 'This field can\'t be empty'

    },
    'ru': {
      _buttonEnter: 'ВОЙТИ',
      _buttonContinue: 'ПРОДОЛЖИТЬ',
      _buttonRecover: 'ВОССТАНОВИТЬ',
      _buttonRegister: 'ЗАРЕГИСТРИРОВАТЬСЯ',
      _buttonConfirm: 'Применить',
      _hintLogin: 'Логин',
      _hintPassword: 'Пароль',
      _hintPasswordConfirm: 'Подтвердите пароль',
      _hintPhone: 'Телефон',
      _hintEmail: 'Email',
      _hintEmailOrPhone: 'Email или телефон',
      _hintPlaceFilter: 'Место',
      _hintDateFilter: 'Дата',
      _hintStartFilter: 'Начало',
      _hintEndFilter: 'Конец',
      _textForgotPassword: 'Забыли пароль ?',
      _textSocialLogin : 'Войти через соц.сети',
      _textEmailInboxCheckPrompt: 'ПРОВЕРЬТЕ ПОЧТУ!',
      _textEmailSent: 'Мы отправили вам  email инструкции по восстановлению пароля.',
      _textEmailOrPhonePrompt: 'Введите email или телефон аккаунта, доступ к которому был утрачен',
      _textSuccessfulRegisration: 'Регистрация успешно завершена и ты можешь начать работу с приложением!',
      _textHello: 'ПРИВЕТ, ',
      _textClearFilter: 'Очистить',
      _textFilter: 'Фильтр',
      _textPlace: 'место',
      _textComfort: 'Удобства',
      _textPrint: 'Печать',
      _textTeaCoffee: 'Чай/кофе',
      _textConferenceRoom: 'Конференц-зал',
      _textKitchen: 'Кухня',
      _textBycicleParkFilter: 'Парковка для велосипедов',
      _errorEmptyLogin : 'Логин не может быть пустым',
      _errorEmptyPassword: 'Пароль не может быть пустым',
      _errorEmptyPasswordConfirm: '\'Подтврерждение пароль\' не может быть пустым',
      _errorNotMatchingPasswords: 'Пароли не соответствуют, проверте пожалуйста',
      _errorEmptyPhone: 'Телефон не может быть пустым',
      _errorEmptyEmail: 'Email не может быть пустым',
      _errorEmptyEmailOrPhone: ' Не может быть пустым',
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

  String get bConfirm {
      return _localizedValues[locale.languageCode][_buttonConfirm];
    }

  String get tForgotPassword {
    return _localizedValues[locale.languageCode][_textForgotPassword];
  }

  String get tSocialLogin  {
    return _localizedValues[locale.languageCode][_textSocialLogin];
  }

  String get tHello => _localizedValues[locale.languageCode][_textHello];

  String get tSuccessfulRegistration =>
      _localizedValues[locale.languageCode][_textSuccessfulRegisration];

  String get tPromptEmailCheck =>
      _localizedValues[locale.languageCode][_textEmailInboxCheckPrompt];

  String get tRecoveryEmailSent =>
      _localizedValues[locale.languageCode][_textEmailSent];

  String get tEmailOrPhonePrompt =>
      _localizedValues[locale.languageCode][_textEmailOrPhonePrompt];

  String get tClear =>
      _localizedValues[locale.languageCode][_textClearFilter];

  String get tFilter =>
      _localizedValues[locale.languageCode][_textFilter];

  String get tPlace =>
      _localizedValues[locale.languageCode][_textPlace];

  String get tParkForBicycle =>
      _localizedValues[locale.languageCode][_textBycicleParkFilter];


  String get tComfort =>
      _localizedValues[locale.languageCode][_textComfort];

  String get tPrint =>
      _localizedValues[locale.languageCode][_textPrint];

  String get tTeaOrCoffee =>
      _localizedValues[locale.languageCode][_textTeaCoffee];

  String get tConferenceRoom =>
      _localizedValues[locale.languageCode][_textConferenceRoom];

  String get tKitchen =>
      _localizedValues[locale.languageCode][_textKitchen];

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

  String get eEmptyEmailOrPhone => _localizedValues[locale.languageCode][_errorEmptyEmailOrPhone];

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

  String get hEmailOrPhone =>
      _localizedValues[locale.languageCode][_hintEmailOrPhone];


  String get hPlace =>
      _localizedValues[locale.languageCode][_hintPlaceFilter];

  String get hDate =>
      _localizedValues[locale.languageCode][_hintDateFilter];

  String get hStart =>
      _localizedValues[locale.languageCode][_hintStartFilter];

  String get hEnd =>
      _localizedValues[locale.languageCode][_hintEndFilter];

}