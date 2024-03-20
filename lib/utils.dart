import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/core/theme/colors.dart';
import 'package:logger/logger.dart';

logInfo(Object message) {
  Logger().i(message.toString());
}

logError(Object message) {
  Logger().e(message.toString());
}

showToast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: Pallete.orange,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
