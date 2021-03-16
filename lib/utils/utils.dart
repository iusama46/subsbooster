import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utils{
  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

}