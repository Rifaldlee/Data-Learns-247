import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

const ColorScheme appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kBlueColor,
  onPrimary: kWhiteColor,
  secondary: kGreenColor,
  onSecondary: kWhiteColor,
  error: kRedColor,
  onError: kWhiteColor,
  surface: kBackgroundColor,
  onSurface: kWhiteColor
);

final ThemeData appTheme = ThemeData.from(colorScheme: appColorScheme);

const FontWeight light = FontWeight.w300;
const FontWeight regular = FontWeight.w400;
const FontWeight medium = FontWeight.w500;
const FontWeight semiBold = FontWeight.w600;
const FontWeight bold = FontWeight.w700;
const FontWeight extraBold = FontWeight.w800;
const FontWeight black = FontWeight.w900;

TextStyle _textStyle({
  required BuildContext context,
  required double size,
  FontWeight fontWeight = regular
}) => GoogleFonts.openSans(textStyle: TextStyle(fontSize: size, fontWeight: fontWeight));

TextTheme appTextTheme(context) =>
  GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).copyWith(
    headlineLarge: _textStyle(context: context, size: 24, fontWeight: bold),
    headlineMedium: _textStyle(context: context, size: 18, fontWeight: bold),
    headlineSmall: _textStyle(context: context, size: 12, fontWeight: bold),
    labelLarge: _textStyle(context: context, size: 16, fontWeight: semiBold),
    labelMedium: _textStyle(context: context, size: 13, fontWeight: semiBold),
    labelSmall: _textStyle(context: context, size: 8, fontWeight: semiBold),
    bodyLarge: _textStyle(context: context, size: 14),
    bodyMedium: _textStyle(context: context, size: 12),
    bodySmall: _textStyle(context: context, size: 9)
  );

//Size
const double bottomNavHeight = 60;

class AppTheme {
  AppTheme._();

  static getAppTheme(BuildContext context) {
    return appTheme.copyWith(textTheme: appTextTheme(context));
  }
}
