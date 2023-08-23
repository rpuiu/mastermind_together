import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

const double fontSize = 16;
const double groupCardWidth = 223.20;
const double groupCardHeight = 336;
const double drawerMaxWidth = 260.0;
const oneColContentWidth = 376.0;

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
