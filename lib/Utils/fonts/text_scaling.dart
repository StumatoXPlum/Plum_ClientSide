import 'dart:math';
import 'package:flutter/material.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 1.2, double minTextScaleFactor = 0.85}) {
    final width = MediaQuery.of(context).size.width;
    const double baseWidth = 390;
    double scale = width / baseWidth;
    return max(minTextScaleFactor, min(scale, maxTextScaleFactor));
  }
}
