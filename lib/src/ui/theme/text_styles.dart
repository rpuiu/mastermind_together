import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/color_scheme.dart';

const String fontFamily = 'Inter';
const Color textColor = darkerPrimaryColor;
const Color textPlaceholderColor = placeholderColor;

// new
const Color whiteColor = Colors.white; //TODO Updated move to color_scheme
const Color labelTextColor = Color(0xFF1E1F38); //TODO Updated move to color_scheme
const Color bodyTextColor = Color(0xFF0C0F15); //TODO Updated move to color_scheme
const Color bodyLightTextColor = Color(0xFF585D6E); //TODO Updated move to color_scheme
const Color bodyButtonInactiveTextColor = Color(0xFF758D78); //TODO Updated move to color_scheme
const Color bodyButtonActiveTextColor = Color(0xFF16311C); //TODO Updated move to color_scheme
const Color buttonInactiveBackgroundColor = Color(0xFFF0F9EF); //TODO Updated move to color_scheme
const Color buttonActiveBackgroundColor = Color(0xFFD6F2D3); //TODO Updated move to color_scheme
const Color borderColor = Color(0xFFB6B9C5); //TODO Updated move to color_scheme
const Color headingTextColor = Color(0xFF0C3E48); //TODO Updated move to color_scheme
const Color backgroundColor = Color(0xFFFDFEFF); //TODO Updated move to color_scheme
const Color drawerBgColor = Color(0xFF161618); //TODO Updated move to color_scheme
const Color menuBtnColor = Color(0xFFEFEFEF); //TODO Updated move to color_scheme
const Color drawerBorderColor = Color(0xFF1F1F22); //TODO Updated move to color_scheme
const Color iconColor = Color(0xFFB7DCE4); //TODO Updated move to color_scheme
const Color categoryBgColor = Color(0xFFE8F2F8); //TODO Updated move to color_scheme

const TextStyle menuBtnTextRegular = TextStyle(
  color: menuBtnColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1.40,
);

const TextStyle headingText = TextStyle(
  color: headingTextColor,
  fontSize: 20,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
  height: 1,
); //UPDATED

const TextStyle labelText = TextStyle(
  color: labelTextColor,
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1.40,
); //Updated

const TextStyle bodySemiBold = TextStyle(
  color: bodyTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
  height: 1.40,
); //Updated

const TextStyle bodyRegular = TextStyle(
  color: bodyLightTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1.40,
); //Updated

const TextStyle bodyMediumInactive = TextStyle(
  color: bodyButtonInactiveTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
  height: 1.50,
); //Updated

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
  color: whiteColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w700,
);
