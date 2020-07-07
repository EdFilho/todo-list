import 'package:flutter/material.dart';

const brightness = Brightness.dark;
const primaryColor = const Color(0xFF333366);
const accentColor = const Color(0xFF736AB7);

final titleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 22.0,
);

final regularTextStyle = TextStyle(
  color: const Color(0xffb6b2df),
  fontSize: 12.0,
  fontWeight: FontWeight.w400
);

ThemeData appTheme() {
  return ThemeData(
    brightness: brightness,
    primaryColor: primaryColor,
    accentColor: accentColor,
    scaffoldBackgroundColor: Color(0xFF736AB7),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}