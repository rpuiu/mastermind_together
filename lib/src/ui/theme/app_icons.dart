import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

enum IconState {
  defaultState,
  hoverState,
  activeState,
}

class AppIcons {
  static Widget award([IconState state = IconState.defaultState]) => _icon('assets/icons/award.svg', state);

  static Widget calendar([IconState state = IconState.defaultState]) => _icon('assets/icons/calendar.svg', state);

  static Widget calendar2([IconState state = IconState.defaultState]) => _icon('assets/icons/calendar-2.svg', state);

  static Widget home([IconState state = IconState.defaultState]) => _icon('assets/icons/home.svg', state);

  static Widget lampOn([IconState state = IconState.defaultState]) => _icon('assets/icons/lamp-on.svg', state);

  static Widget lifebuoy([IconState state = IconState.defaultState]) => _icon('assets/icons/lifebuoy.svg', state);

  static Widget login([IconState state = IconState.defaultState]) => _icon('assets/icons/login.svg', state);

  static Widget logout([IconState state = IconState.defaultState]) => _icon('assets/icons/logout.svg', state);

  static Widget message([IconState state = IconState.defaultState]) => _icon('assets/icons/message.svg', state);

  static Widget note([IconState state = IconState.defaultState]) => _icon('assets/icons/note.svg', state);

  static Widget note2([IconState state = IconState.defaultState]) => _icon('assets/icons/note-2.svg', state);

  static Widget notification([IconState state = IconState.defaultState]) => _icon('assets/icons/notification.svg', state);

  static Widget profile2user([IconState state = IconState.defaultState]) => _icon('assets/icons/profile-2user.svg', state);

  static Widget settings2([IconState state = IconState.defaultState]) => _icon('assets/icons/settings-2.svg', state);

  static Widget menu([IconState state = IconState.activeState]) => _icon('assets/icons/menu.svg', state);

  static Widget privacyPolicy([IconState state = IconState.defaultState]) => _icon('assets/icons/privacy-policy.svg', state);

  static Widget categories([IconState state = IconState.defaultState]) => _icon('assets/icons/categories.svg', state);

  static Widget getIcon(String iconName, IconState state) {
    switch (iconName) {
      case 'home':
        return home(state);
      case 'profile2user':
        return profile2user(state);
      case 'award':
        return award(state);
      case 'calendar2':
        return calendar2(state);
      case 'notification':
        return notification(state);
      case 'message':
        return message(state);
      case 'settings2':
        return settings2(state);
      case 'logout':
        return logout(state);
      case 'menu':
        return menu(state);
      case 'privacy-policy':
        return privacyPolicy(state);
      case 'categories':
        return categories(state);
      default:
        return home(state);
    }
  }

  static Widget _icon(String assetPath, IconState state) {
    Color color;
    switch (state) {
      case IconState.defaultState:
        color = defaultMenuIconColor;
        break;
      case IconState.hoverState:
        color = hoverMenuIconColor;
        break;
      case IconState.activeState:
        color = activeMenuIconColor;
        break;
    }
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        assetPath,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
