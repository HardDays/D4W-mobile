import 'package:flutter/material.dart';

class StringResources {
  final Locale locale;

  static final String _buttonEnter = 'buttonEnter';
  static final String _buttonContinue = 'buttonContinue';
  static final String _buttonRecover = 'buttonRecover';
  static final String _buttonRegister = 'buttonRegister';
  static final String _buttonConfirm = 'buttonConfirm';
  static final String _buttonSave = 'buttonSave';
  static final String _buttonBook = 'buttonBook';

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
  static final String _hintPopular = 'hintPopular';

  static final String _textForgotPassword = 'textForgotPassword';
  static final String _textSocialLogin = 'textSocialLogin';
  static final String _textHello = 'textHello';
  static final String _textSuccessfulRegistration = 'textSuccessfulRegistration';
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
  static final String _textBicycleParkFilter = 'textBycicleFilter';
  static final String _textKitchen = 'textKitchen';
  static final String _textWherever = 'textWherever';
  static final String _textNearby = 'textNearby';
  static final String _textDateExplanation = 'textDateExplanation';
  static final String _textMonday = 'textMonday';
  static final String _textTuesday = 'textTuesday';
  static final String _textWednesday = 'textWednesdayn';
  static final String _textThursday = 'textThursday';
  static final String _textFriday = 'textFriday';
  static final String _textSaturday = 'textSaturday';
  static final String _textSunday = 'textSunday';
  static final String _textMainInfo = 'textMainInfo';
  static final String _textFreePlaces = 'textFreePlaces';
  static final String _textRemainingTime = 'textRemainingTime';
  static final String _textGuests = 'textGuests';
  static final String _textWorkingHours = 'textWorkingHours';
  static final String _textContacts = 'textContacts';
  static final String _textYes = 'textYes';
  static final String _textNo = 'textNo';
  static final String _textMap = 'textMap';
  static final String _textPrivateKabinet = 'textPrivateKabinet';
  static final String _textHistory = 'textHistory';
  static final String _textPaymentOption = 'textPaymentOption';
  static final String _textHelp = 'textHelp';
  static final String _textNoBookings = 'textNoBookings';
  static final String _textFreeEquipment = 'textFreeEquipment';
  static final String _textPaidEquipment = 'textPaidEquipment';
  static final String _textClosed = 'textClosed';
  static final String _textTerminate = 'textTerminate';
  static final String _textExtend = 'textExtend';
  static final String _textFreeMinutes = 'textFreeMinutes';
  static final String _textHours = 'textHours';
  static final String _textMinutes = 'textMinutes';
  static final String _textSeconds = 'textSeconds';




  static final String _tipPrinter = "toolTipPrinter";
  static final String _tipKitchen = "toolTipKitchen";
  static final String _tipBikeStorage = "toolTipBikeStorage";
  static final String _tipConferenceRoom = "toolTipConferenceRoom";
  static final String _tipCoffeeTea = "toolTipCoffeeTea";







  static final String _errorEmptyLogin = 'errorEmptyLogin';
  static final String _errorEmptyPassword = 'errorEmptyPassword';
  static final String _errorEmptyPasswordConfirm = 'errorEmptyPasswordConfirm';
  static final String _errorNotMatchingPasswords = 'errorMatchingPasswords';
  static final String _errorEmptyPhone = 'errorEmptyPhone';
  static final String _errorEmptyEmail = 'errorEmptyEmail';
  static final String _errorEmptyEmailOrPhone = 'errorEmptyEmailOrPhone';

  static final String _messageNoInternet = 'messageNoInternet';
  static final String _messageServerError = 'messageServerError';




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
      _buttonSave: 'save',
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
      _hintPopular : 'Popular',
      _textForgotPassword: 'Forgot password ?',
      _textSocialLogin : 'Log in through social networks',
      _textEmailInboxCheckPrompt: 'CHECK YOUR MAILS',
      _textEmailSent: 'We have sent you an email with instructions to restore your password',
      _textEmailOrPhonePrompt: 'Enter the email or phone number for the accout you want to recover',
      _textSuccessfulRegistration: 'You have successfully registered and you can now start working with the app!',
      _textHello: 'Hello, ',
      _textClearFilter: 'Clear',
      _textFilter: 'Filter',
      _textPlace: 'Place',
      _textComfort: 'Comfort',
      _textPrint: 'Print',
      _textTeaCoffee: 'Tea/Coffee',
      _textConferenceRoom: 'Conference room',
      _textKitchen: 'Kitchen',
      _textBicycleParkFilter: 'Bike storage',
      _textNearby : 'Nearby',
      _textWherever : 'Wherever',
      _textMonday : 'Mon',
      _textTuesday : 'Tue',
      _textWednesday: 'Wed',
      _textThursday: 'Thur',
      _textFriday: 'Fri',
      _textSaturday: 'Sat',
      _textSunday: 'Sun',
      _textDateExplanation: 'pick a date or date interval',
      _textMainInfo: 'Main information',
      _textFreePlaces : 'Free places',
      _textRemainingTime : 'Remaining time',
      _textGuests : 'Guests',
      _textWorkingHours : 'Working hours',
      _textContacts : 'Contacts',
      _buttonBook : 'Book',
      _textYes : 'yes',
      _textNo : 'No',
      _textMap : 'Map',
      _textPrivateKabinet : 'Profile',
      _textHistory : 'History',
      _textPaymentOption: 'Payment options',
      _textHelp: 'Help',
      _textNoBookings : 'No bookings yet',
      _textFreeEquipment: 'Free use of ',
      _textPaidEquipment: 'Additional fees apply for the use of',
      _textClosed: 'Closed',
      _textTerminate: 'Terminate',
      _textExtend: 'Extend',
      _textFreeMinutes: 'Free minutes',
      _textHours: 'Hours',
      _textMinutes: 'Minutes',
      _textSeconds: 'Seconds',
      _errorEmptyLogin : 'Login can\'t be empty',
      _errorEmptyPassword: 'Password can\'t be empty',
      _errorEmptyPasswordConfirm: 'This field can\'t be empty',
      _errorNotMatchingPasswords: 'Passwords don\'t match, please try again',
      _errorEmptyPhone: 'This field can\'t be empty',
      _errorEmptyEmail: 'This field can\'t be empty',
      _errorEmptyEmailOrPhone: 'This field can\'t be empty',
      _messageNoInternet: 'No internet connection',
      _messageServerError: 'Server Error',
      _tipPrinter : "Printer and scanner",
      _tipKitchen : "Kitchen",
      _tipBikeStorage : "Bike storage",
      _tipConferenceRoom : "Conference Room",
      _tipCoffeeTea : "Coffee and/or Tea"

    },
    'ru': {
      _buttonEnter: 'ВОЙТИ',
      _buttonContinue: 'ПРОДОЛЖИТЬ',
      _buttonRecover: 'ВОССТАНОВИТЬ',
      _buttonRegister: 'ЗАРЕГИСТРИРОВАТЬСЯ',
      _buttonConfirm: 'Применить',
      _buttonSave: 'Сохранить',
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
      _hintPopular : 'Популярное',
      _textForgotPassword: 'Забыли пароль ?',
      _textSocialLogin : 'Войти через соц.сети',
      _textEmailInboxCheckPrompt: 'ПРОВЕРЬТЕ ПОЧТУ!',
      _textEmailSent: 'Мы отправили вам  email инструкции по восстановлению пароля.',
      _textEmailOrPhonePrompt: 'Введите email или телефон аккаунта, доступ к которому был утрачен',
      _textSuccessfulRegistration: 'Регистрация успешно завершена и ты можешь начать работу с приложением!',
      _textHello: 'ПРИВЕТ, ',
      _textClearFilter: 'Очистить',
      _textFilter: 'Фильтр',
      _textPlace: 'место',
      _textComfort: 'Удобства',
      _textPrint: 'Печать',
      _textTeaCoffee: 'Чай/кофе',
      _textConferenceRoom: 'Конференц-зал',
      _textKitchen: 'Кухня',
      _textNearby : 'Рядом',
      _textWherever : 'Где угодно',
      _textMonday : 'Пн',
      _textTuesday : 'ВТ',
      _textWednesday: 'СР',
      _textThursday: 'ЧТ',
      _textFriday: 'ПТ',
      _textSaturday: 'СБ',
      _textSunday: 'ВС',
      _textBicycleParkFilter: 'Парковка для велосипедов',
      _textDateExplanation: 'Выберите дату или диапазон дат',
      _textMainInfo: 'Основная информация',
      _textFreePlaces : 'Свободных мест',
      _textRemainingTime : 'Оставшееся время:',
      _textGuests : 'Гости:',
      _textWorkingHours : 'Время работы',
      _textContacts : 'Контакты',
      _textMap: 'Карта',
      _textPrivateKabinet : 'Личный кабинет',
      _textHistory : 'История',
      _textPaymentOption: 'Способы оплаты',
      _textHelp: 'Помощь',
      _textNoBookings: 'История пуста',
      _buttonBook : 'Забронировать',
      _textYes : 'да',
      _textNo : 'нет',
      _textFreeEquipment: 'Бесплатно можно пользоваться ',
      _textPaidEquipment: 'За дополнительную плату можно пользоваться',
      _textClosed: 'Закрыто',
      _textTerminate: 'Завершить',
      _textExtend: 'Продлить',
      _textHours: 'Часы',
      _textMinutes: 'минуты',
      _textSeconds: 'секунды',
      _textFreeMinutes: 'Бесплатные минуты',
      _errorEmptyLogin : 'Логин не может быть пустым',
      _errorEmptyPassword: 'Пароль не может быть пустым',
      _errorEmptyPasswordConfirm: '\'Подтврерждение пароль\' не может быть пустым',
      _errorNotMatchingPasswords: 'Пароли не соответствуют, проверте пожалуйста',
      _errorEmptyPhone: 'Телефон не может быть пустым',
      _errorEmptyEmail: 'Email не может быть пустым',
      _errorEmptyEmailOrPhone: ' Не может быть пустым',
      _messageNoInternet: 'Нет соединение к интернету',
      _messageServerError: 'Ощибка сервера',
      _tipPrinter : "принтером и сканером",
      _tipKitchen : "Кухной",
      _tipBikeStorage : "парковкой для велосипедов",
      _tipConferenceRoom : "конффффф",
      _tipCoffeeTea : "чай/кофе"
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

  String get bSave {
    return _localizedValues[locale.languageCode][_buttonSave];
  }


  String get bBook =>
      _localizedValues[locale.languageCode][_buttonBook];

  String get tForgotPassword {
    return _localizedValues[locale.languageCode][_textForgotPassword];
  }

  String get tSocialLogin  {
    return _localizedValues[locale.languageCode][_textSocialLogin];
  }

  String get tHello => _localizedValues[locale.languageCode][_textHello];

  String get tSuccessfulRegistration =>
      _localizedValues[locale.languageCode][_textSuccessfulRegistration];

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
      _localizedValues[locale.languageCode][_textBicycleParkFilter];


  String get tComfort =>
      _localizedValues[locale.languageCode][_textComfort];

  String get tMap =>
      _localizedValues[locale.languageCode][_textMap];

  String get tPrivateKabinet =>
      _localizedValues[locale.languageCode][_textPrivateKabinet];

  String get tHistory =>
      _localizedValues[locale.languageCode][_textHistory];

  String get tPaymentOption =>
      _localizedValues[locale.languageCode][_textPaymentOption];

  String get tHelp =>
      _localizedValues[locale.languageCode][_textHelp];

String get tNoBokings =>
      _localizedValues[locale.languageCode][_textNoBookings];

  String get tPrint =>
      _localizedValues[locale.languageCode][_textPrint];

  String get tTeaOrCoffee =>
      _localizedValues[locale.languageCode][_textTeaCoffee];

  String get tConferenceRoom =>
      _localizedValues[locale.languageCode][_textConferenceRoom];

  String get tKitchen =>
      _localizedValues[locale.languageCode][_textKitchen];

  String get tNearby =>
      _localizedValues[locale.languageCode][_textNearby];

  String get tWherever =>
      _localizedValues[locale.languageCode][_textWherever];

  String get tDateExplanation =>
      _localizedValues[locale.languageCode][_textDateExplanation];

  String get tMonday => _localizedValues[locale.languageCode][_textMonday];

  String get tTuesday => _localizedValues[locale.languageCode][_textTuesday];

  String get tWednesday => _localizedValues[locale.languageCode][_textWednesday];

  String get tThursday => _localizedValues[locale.languageCode][_textThursday];

  String get tFriday => _localizedValues[locale.languageCode][_textFriday];

  String get tSaturday => _localizedValues[locale.languageCode][_textSaturday];

  String get tSunday => _localizedValues[locale.languageCode][_textSunday];

  String get tFreeMinutes =>
      _localizedValues[locale.languageCode][_textFreeMinutes];

  String get tHours =>
      _localizedValues[locale.languageCode][_textHours];

  String get tMinutes =>
      _localizedValues[locale.languageCode][_textMinutes];

  String get tSeconds =>
      _localizedValues[locale.languageCode][_textSeconds];



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

  String get hPopular =>
      _localizedValues[locale.languageCode][_hintPopular];

  String get mNoInternet =>
      _localizedValues[locale.languageCode][_messageNoInternet];

  String get mServerError =>
      _localizedValues[locale.languageCode][_messageServerError];

  String get tMainInfo =>
      _localizedValues[locale.languageCode][_textMainInfo];

  String get tFreePlaces =>
      _localizedValues[locale.languageCode][_textFreePlaces];

  String get tRemainingTime =>
      _localizedValues[locale.languageCode][_textRemainingTime];

  String get tGuests =>
      _localizedValues[locale.languageCode][_textGuests];

  String get tWorkingHours =>
      _localizedValues[locale.languageCode][_textWorkingHours];

  String get tContacts =>
      _localizedValues[locale.languageCode][_textContacts];

  String get tYes =>
      _localizedValues[locale.languageCode][_textYes];

  String get tNo =>
      _localizedValues[locale.languageCode][_textNo];

  String get tFreeEquipment =>
      _localizedValues[locale.languageCode][_textFreeEquipment];

  String get tPaidEquipment =>
      _localizedValues[locale.languageCode][_textPaidEquipment];

  String get tClosed =>
      _localizedValues[locale.languageCode][_textClosed];

  String get tTerminate =>
      _localizedValues[locale.languageCode][_textTerminate];

  String get tExtend =>
      _localizedValues[locale.languageCode][_textExtend];

  String get tipPrinter =>
      _localizedValues[locale.languageCode][_tipPrinter];

  String get tipTeaCoffee =>
      _localizedValues[locale.languageCode][_tipCoffeeTea];

  String get tipConferenceRoom =>
      _localizedValues[locale.languageCode][_tipConferenceRoom];


  String get tipKitchen =>
      _localizedValues[locale.languageCode][_tipKitchen];

  String get tipBikeStorage =>
      _localizedValues[locale.languageCode][_tipBikeStorage];



}