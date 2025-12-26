import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  static double screenWidth(BuildContext context) => ScreenUtil().screenWidth;
  static double screenHeight(BuildContext context) => ScreenUtil().screenHeight;
  static double pagePadding = 28.0.w;
  static double widgetSpacing = 16.0.h;
  static double borderRadius = 8.0.r;
  static double borderRadiusL = 12.0.r;
  static double formSpacing = 30.0.h;
  static double defaultPadding = 16.0.w; // legacy name
  static double spaceBtwSections = 32.0.h;
  static double defaultSpace = defaultPadding; // alias
  static double spaceBtwItems = 16.0.w; // horizontal item spacing
  static double xs = 4.0.w;
  static double sm = 8.0.w;
  static double md = 12.0.w;
  static double lg = 16.0.w;
  static double borderRadiusSm = 6.0.r;
  static double borderRadiusLg = 16.0.r;
}
