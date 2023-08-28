import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

const double fontSize = 16;
const double groupCardWidth = 223.20;
const double goalCardHeight = 250;
const double goalCardWidth = 400;
const double groupCardHeight = 336;
const double drawerMaxWidth = 260.0;
const oneColContentWidth = 376.0;

const int characterMaxLength = 280;

SizedBox halfSpace = const SizedBox(height: fontSize / 2);
SizedBox xSpace = const SizedBox(height: fontSize * 1);
SizedBox xHalfSpace = const SizedBox(height: fontSize * 1.5);
SizedBox xxSpace = const SizedBox(height: fontSize * 2);
SizedBox xxxSpace = const SizedBox(height: fontSize * 3);
SizedBox xxxxSpace = const SizedBox(height: fontSize * 4);

SizedBox wHalfSpace = const SizedBox(width: fontSize / 2);
SizedBox wXSpace = const SizedBox(width: fontSize * 1);
SizedBox wXXSpace = const SizedBox(width: fontSize * 2);

BorderRadius borderRadius = BorderRadius.circular(8);

RoundedRectangleBorder customBorder = RoundedRectangleBorder(
  side: const BorderSide(width: 0.50, color: borderColor),
  borderRadius: BorderRadius.circular(14),
);

double calculateHorizontalMargin(double screenWidth) {
  return screenWidth > 1200
      ? 2 * fontSize
      : screenWidth > 800
          ? 50
          : 20;
}

double calculateVerticalMargin(double screenWidth) {
  return screenWidth > 1200
      ? 20
      : screenWidth > 800
          ? 20
          : 10;
}
