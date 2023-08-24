import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    tabBarTheme: tabBarTheme,
    scrollbarTheme: ScrollbarThemeData(thumbColor: MaterialStateProperty.all(bodyLightTextColor)),
    timePickerTheme: timePickerThemeData,
    // colorScheme: lightThemeColors,
    // useMaterial3: true,
    // textTheme: textTheme,
    // buttonTheme: ButtonThemeData(
    //   buttonColor: lightThemeColors.primary,
    //   textTheme: ButtonTextTheme.primary,
    // ),
    // canvasColor: lightThemeColors.surface,
  );

  static TabBarTheme tabBarTheme = const TabBarTheme(
    unselectedLabelColor: bodyButtonInactiveTextColor, // Unselected tab color
    labelColor: bodyButtonActiveTextColor, // Selected tab color
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: bodyButtonActiveTextColor, width: 0.8),
      ),
    ),
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

  static TimePickerThemeData timePickerThemeData = TimePickerThemeData(
    // backgroundColor: drawerBgColor,
    helpTextStyle: headingText,
    dialHandColor: hoverMenuIconColor,
    hourMinuteTextColor: labelTextColor,
    dayPeriodTextColor: labelTextColor,
    shape: customBorder,
    //TODO implement OK CANCEL buttons for the time picker
    // cancelButtonStyle:,
    // confirmButtonStyle:,
  );
}
