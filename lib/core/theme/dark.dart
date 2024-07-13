import 'package:flutter/material.dart';
import '../utils/my_color.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Mulish',
  primaryColor: MyColor.primaryColor,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  //scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  hintColor: MyColor.gbr,
  focusColor: MyColor.gbr,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: MyColor.secondaryColor,
    selectedItemColor: MyColor.primaryColor,
    unselectedItemColor: MyColor.primaryText,
    type: BottomNavigationBarType.fixed,
  ),
);
