import 'package:flutter/material.dart';

Color getColorFromUsername(String username) {
  int hash = username.hashCode;
  int r = (hash & 0xFF0000) >> 16;
  int g = (hash & 0x00FF00) >> 8;
  int b = hash & 0x0000FF;

  // This will generate a color from the username's hashcode.
  return Color.fromRGBO(r, g, b, 1);
}

Color getCategoryColor(String category) {
  // Average saturation and brightness from provided colors
  double avgSaturation = (6 + 10 + 6 + 6) / 4 / 100; // dividing by 100 to convert to a 0-1 scale
  double avgBrightness = (97 + 99 + 97 + 97) / 4 / 100;

  // Generate a hue based on the hash of the category
  // We'll mod by 360 because hue is typically represented in degrees between 0 and 360
  double hue = category.hashCode % 360;

  // Convert HSB to RGB
  var color = HSVColor.fromAHSV(1.0, hue, avgSaturation, avgBrightness);
  return color.toColor();
}
