import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF22B2CF);
const Color hoverColor = Color(0xFF1FA0BA);
const Color activeColor = Color(0xFF1B8EA6);
const Color disabledColor = Color(0xFFBAE7F0);
const Color secondaryColor = Color(0xFFCF7121);
const Color surfaceColor = Color(0xFFE9F7FA);
const Color lightSurfaceColor = Color(0xFFF4FBFD);
const Color darkerPrimaryColor = Color(0xFF0C3E48);
const Color errorColor = Color(0xFFCF2A22);
const Color placeholderColor = Color(0xFF728D93);
const Color doneColor = Color(0xFF2C9D1A);

const shadow = BoxShadow(
  color: Color(0x33000000),
  blurRadius: 4,
  offset: Offset(0, 2),
  spreadRadius: 0,
);

ColorScheme lightThemeColors = const ColorScheme(
  // The background color of the app.
  background: surfaceColor,

  // The color of elements on top of the background color.
  onBackground: darkerPrimaryColor,
  // Generally this should be a color that contrasts with the background color

  // The color of the app's primary widget.
  primary: primaryColor,

  // The color of text and icons on top of the primary color.
  onPrimary: Colors.white,
  // Generally this should be a color that contrasts with the primary color

  // The color of the app's secondary widget.
  secondary: secondaryColor,

  // The color of text and icons on top of the secondary color.
  onSecondary: Colors.white,
  // Generally this should be a color that contrasts with the secondary color

  // The color of the app's surface widgets.
  surface: surfaceColor,
  surfaceVariant: lightSurfaceColor,

  // The color of text and icons on top of the surface color.
  onSurface: darkerPrimaryColor,
  // Generally this should be a color that contrasts with the surface color

  // The color of the app's error widgets.
  error: errorColor,

  // The color of text and icons on top of the error color.
  onError: Colors.white,
  // Generally this should be a color that contrasts with the error color

  // The brightness of the color scheme.
  brightness: Brightness.light,
);
