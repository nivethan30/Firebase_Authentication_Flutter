import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Poppins',
          ));
}
