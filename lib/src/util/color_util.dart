import 'dart:ui';

Color getColorFromUsername(String username) {
  int hash = username.hashCode;
  int r = (hash & 0xFF0000) >> 16;
  int g = (hash & 0x00FF00) >> 8;
  int b = hash & 0x0000FF;

  // This will generate a color from the username's hashcode.
  return Color.fromRGBO(r, g, b, 1);
}
