import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';

class Utiliy {
  static customSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String msg,
      {double height = 30, Color backgroundColor = secondaryColor}) {
    if (_scaffoldKey == null || _scaffoldKey.currentState == null) {
      return;
    }
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
