import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/app_colors.dart';

class AppToast {
  static void success(String msg) => _show(msg, backgroundColor: AppColors.success);

  static void error(String msg) => _show(msg, backgroundColor: AppColors.error);

  static void warning(String msg) => _show(msg, backgroundColor: AppColors.warning);

  static void info(String msg) => _show(msg, backgroundColor: AppColors.primary);

  static void _show(String msg, {required Color backgroundColor}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
