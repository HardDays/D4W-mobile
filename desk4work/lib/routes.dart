import 'package:desk4work/view/auth/login.dart';
import 'package:desk4work/view/auth/register.dart';
import 'package:flutter/material.dart';

final routes = {
  '/login' : (BuildContext ctx) => LoginScreen(),
  '/register' : (ctx) => RegisterScreen(),
};