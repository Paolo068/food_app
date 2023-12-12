import 'package:flutter/material.dart';

class Pallete {
  static Color orange = const Color.fromRGBO(255, 164, 81, 1);
  static Color lightOrange = const Color.fromRGBO(255, 242, 231, 1);
  static Color darkBlue = const Color.fromRGBO(39, 33, 77, 1);
  static Color lightGrey100 = const Color.fromRGBO(243, 244, 249, 1);
  static Color grey = const Color.fromRGBO(134, 134, 158, 1);
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color lightDark = const Color.fromRGBO(243, 243, 243, 1);
  static Color lightGreen = const Color.fromRGBO(76, 217, 100, 1);
  static Color darkGreen = const Color.fromRGBO(224, 255, 229, 1);
  static Color lightGrey300 = const Color(0xFF787F84).withOpacity(0.3);
}

class AppStyles {
  static TextStyle bodyText = TextStyle(fontSize: 18, color: Pallete.darkBlue, fontWeight: FontWeight.w500);
  static TextStyle headLineText = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Pallete.darkBlue);
}
