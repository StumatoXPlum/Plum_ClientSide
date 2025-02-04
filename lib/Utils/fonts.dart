import 'package:flutter/material.dart';

class AppFonts {
  static const String denton = 'Denton';
  static const String gilroy = 'Gilroy';
}

class AppTextStyles {
  static TextStyle dentonBold = TextStyle(
    fontFamily: AppFonts.denton,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gilroyRegular = TextStyle(
    fontFamily: AppFonts.gilroy,
    fontWeight: FontWeight.normal,
  );
}
