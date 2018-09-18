import 'dart:async';

import 'package:desk4work/utils/string_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomLocalizationsDelegate extends LocalizationsDelegate<StringResources>{

  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<StringResources> load(Locale locale) =>
      SynchronousFuture<StringResources>(StringResources(locale));

  @override
  bool shouldReload(LocalizationsDelegate<StringResources> old) => false;

}


