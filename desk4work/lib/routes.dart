import 'package:desk4work/view/auth/login.dart';
import 'package:desk4work/view/auth/recover/main.dart';
import 'package:desk4work/view/auth/registration/main.dart';
import 'package:flutter/material.dart';

final routes = {
  '/login' : (BuildContext ctx) => LoginScreen(),
  '/register' : (ctx) => RegistrationMainScreen(),
  '/recover' : (ctx) => RecoverMainScreen(),

};