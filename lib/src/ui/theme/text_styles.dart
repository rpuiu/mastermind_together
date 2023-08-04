import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/color_scheme.dart';

const String fontFamily = 'Inter';
const Color textColor = darkerPrimaryColor;
const Color textPlaceholderColor = placeholderColor;
const Color btnTextColor = Colors.white; //TODO move to color_scheme
const Color linkColor = Colors.blue;

const TextStyle h1 = TextStyle(
  color: textColor,
  fontSize: 64,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w700,
);

const TextStyle h2 = TextStyle(
  color: textColor,
  fontSize: 42,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

const TextStyle h3 = TextStyle(
  color: textColor,
  fontSize: 26,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w700,
);
const TextStyle body = TextStyle(
  color: textColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

const TextStyle bodyMediumLink = TextStyle(
  color: textColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline,
);

const TextStyle linkStyle = TextStyle(
  color: linkColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w700,
  decoration: TextDecoration.underline,
);

const TextStyle bodyMedium = TextStyle(
  color: textColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
);

const TextStyle placeholderBodyMedium = TextStyle(
  color: textPlaceholderColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

const TextStyle labelText = TextStyle(
  color: textColor,
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
);

const TextStyle cardTitle = TextStyle(
  color: textColor,
  fontSize: 26,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
);

const TextStyle labelSmall = TextStyle(
  color: textColor,
  fontSize: 10,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

const TextStyle btnText = TextStyle(
  color: btnTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w700,
);
