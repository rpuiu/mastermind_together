import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    tabBarTheme: tabBarTheme,
    scrollbarTheme: scrollBarTheme,
    timePickerTheme: timePickerThemeData,
    progressIndicatorTheme: progressIndicatorTheme,
    textButtonTheme: textButtonThemeData,
    dialogTheme: dialogTheme,
    // useMaterial3: true,
    // textTheme: textTheme,
    // buttonTheme: ButtonThemeData(
    //   buttonColor: lightThemeColors.primary,
    //   textTheme: ButtonTextTheme.primary,
    // ),
    // canvasColor: lightThemeColors.surface,
  );

  static TabBarTheme tabBarTheme = TabBarTheme(
    unselectedLabelColor: defaultMenuIconColor,
    labelColor: hoverMenuIconColor,
    indicator: UnderlineTabIndicator(
      borderRadius: borderRadius,
      borderSide: const BorderSide(color: hoverMenuIconColor, width: 1.5),
    ),
    labelStyle: bodyMedium,
    unselectedLabelStyle: bodyMediumInactive,
  );

  // static TextTheme textTheme = const TextTheme(
  //   displayLarge: h1,
  //   displayMedium: h2,
  //   bodyLarge: bodyMedium,
  //   bodyMedium: body,
  //   bodySmall: labelSmall,
  //   labelLarge: btnText,
  //   labelMedium: placeholderBodyMedium,
  //   labelSmall: labelText,
  //   headlineMedium: h3,
  //   titleMedium: bodyMedium,
  // );

  static TimePickerThemeData timePickerThemeData = TimePickerThemeData(
    // backgroundColor: drawerBgColor,
    helpTextStyle: welcomeTextStyle.copyWith(color: hoverMenuIconColor),
    dialHandColor: hoverMenuIconColor,
    hourMinuteTextColor: labelTextColor,
    dayPeriodTextColor: labelTextColor,
    shape: customBorder,
    //TODO implement OK CANCEL buttons for the time picker
    // cancelButtonStyle:,
    // confirmButtonStyle:,
  );
  static ScrollbarThemeData scrollBarTheme = ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(bodyLightTextColor),
  );

  static ProgressIndicatorThemeData progressIndicatorTheme = const ProgressIndicatorThemeData(
    linearTrackColor: textFieldBorderColor,
    color: hoverMenuIconColor,
  );

  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: hoverMenuIconColor, textStyle: bodyMedium),
  );

  static DialogTheme dialogTheme = DialogTheme(
    titleTextStyle: headingText,
    contentTextStyle: bodyRegular,
    backgroundColor: backgroundColor,
    elevation: 4.0,
    shape: customBorder,
    actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
  );
}
