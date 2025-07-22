import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isMobile(context) => MediaQuery.sizeOf(context).width <= 840;

  static bool isTablet(context) =>
      MediaQuery.sizeOf(context).width > 840 &&
      MediaQuery.sizeOf(context).width <= 120;

  static bool isWindow(context) => MediaQuery.sizeOf(context).width > 1100;
}
