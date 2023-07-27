import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/color_scheme.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    colorScheme: lightThemeColors,
    useMaterial3: true,
    textTheme: textTheme,
    buttonTheme: ButtonThemeData(
      buttonColor: lightThemeColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    canvasColor: lightThemeColors.surface,
  );

  static TextTheme textTheme = const TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    bodyLarge: bodyMedium,
    bodyMedium: body,
    bodySmall: labelSmall,
    labelLarge: btnText,
    labelMedium: placeholderBodyMedium,
    labelSmall: labelText,
    headlineMedium: h3,
    titleMedium: bodyMedium,
  );
}
