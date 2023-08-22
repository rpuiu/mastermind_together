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
const Color drawerBorderColor = Color(0xFF1F1F22); //TODO Updated move to color_scheme
const Color categoryBgColor = Color(0xFFE8F2F8); //TODO Updated move to color_scheme
const Color defaultMenuIconColor = Color(0xFF6D7C80); //TODO Updated move to color_scheme
const Color defaultMenuTextColor = Color(0xFF9B9B9B); //TODO Updated move to color_scheme
const Color hoverMenuIconColor = Color(0xFF22B2CF); //TODO Updated move to color_scheme
const Color hoverMenuTextColor = Color(0xFFEFEFEF); //TODO Updated move to color_scheme
const Color activeMenuIconColor = Color(0xFFB7DCE4); //TODO Updated move to color_scheme
const Color textFieldLabelColor = Color(0xFF0B1420); //TODO Updated move to color_scheme
const Color textFieldHintColor = Color(0xFF8796AD); //TODO Updated move to color_scheme
const Color formTextFieldFillColor = Color(0xFFF6FAFF); //TODO Updated move to color_scheme
const Color textFieldBorderColor = Color(0xFFD3D7E3); //TODO Updated move to color_scheme
const Color buttonBackgroundColor = Color(0xFF162D3A); //TODO Updated move to color_scheme
const Color welcomeTextColor = Color(0xFF161619); //TODO Updated move to color_scheme
const Color subtitleTextColor = Color(0xFF313957); //TODO Updated move to color_scheme
const Color linkTextColor = Color(0xFF1D4AE8); //TODO Updated move to color_scheme
const Color copyrightTextColor = Color(0xFF959CB5); //TODO Updated move to color_scheme

TextStyle copyrightTextStyle = linkTextStyle.copyWith(color: copyrightTextColor);

TextStyle linkTextStyle = const TextStyle(
  color: linkTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1,
  letterSpacing: 0.16,
);

TextStyle subtitleTextStyle = const TextStyle(
  color: subtitleTextColor,
  fontSize: 18,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1.60,
  letterSpacing: 0.18,
);

TextStyle welcomeTextStyle = const TextStyle(
  color: welcomeTextColor,
  fontSize: 32,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
  height: 1,
  letterSpacing: 0.32,
);

const TextStyle buttonTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 20,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1,
  letterSpacing: 0.20,
); //UPDATED

TextStyle inactiveButtonTextStyle = buttonTextStyle.copyWith(color: defaultMenuTextColor);

const formLabelTextStyle = TextStyle(
  color: textFieldLabelColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1,
  letterSpacing: 0.16,
); //UPDATED

TextStyle formHintTextStyle = formLabelTextStyle.copyWith(color: textFieldHintColor); //UPDATED

const TextStyle menuBtnTextRegular = TextStyle(
  color: hoverMenuTextColor,
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  height: 1.40,
); //UPDATED

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

TextStyle mobileLabelTextStyle = labelText.copyWith(height: 1, letterSpacing: 0.14, color: textFieldLabelColor);

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
