import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

enum IconState {
  defaultState,
  hoverState,
  activeState,
  done,
  fail,
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

  static Widget settings([IconState state = IconState.defaultState]) => _icon('assets/icons/settings-2.svg', state);

  static Widget menu([IconState state = IconState.activeState]) => _icon('assets/icons/menu.svg', state);

  static Widget privacyPolicy([IconState state = IconState.defaultState]) => _icon('assets/icons/privacy-policy.svg', state);

  static Widget categories([IconState state = IconState.defaultState]) => _icon('assets/icons/categories.svg', state);

  static Widget add([IconState state = IconState.defaultState]) => _icon('assets/icons/add.svg', state);

  static Widget arrowDown([IconState state = IconState.defaultState]) => _icon('assets/icons/arrow-down.svg', state);

  static Widget check([IconState state = IconState.done]) => _icon('assets/icons/check.svg', state);

  static Widget close([IconState state = IconState.fail]) => _icon('assets/icons/close.svg', state);

  static Widget info([IconState state = IconState.defaultState]) => _icon('assets/icons/info.svg', state);

  static Widget share([IconState state = IconState.defaultState]) => _icon('assets/icons/share.svg', state);

  static Widget send([IconState state = IconState.defaultState]) => _icon('assets/icons/send.svg', state);

  static Widget edit([IconState state = IconState.defaultState]) => _icon('assets/icons/edit.svg', state);

  static Widget delete([IconState state = IconState.defaultState]) => _icon('assets/icons/delete.svg', state);

  static Widget swap([IconState state = IconState.defaultState]) => _icon('assets/icons/swap.svg', state);

  static Widget done([IconState state = IconState.defaultState]) => _icon('assets/icons/done.svg', state);

  static Widget infoSnack([IconState state = IconState.defaultState]) => _icon('assets/icons/info-snack.svg', state);

  static Widget error([IconState state = IconState.fail]) => _icon('assets/icons/error.svg', state);

  static Widget success([IconState state = IconState.done]) => _icon('assets/icons/success.svg', state);

  static Widget arrowDownSquare([IconState state = IconState.defaultState]) => _icon('assets/icons/arrow-down-square.svg', state);

  static Widget serenityGuide([IconState state = IconState.defaultState]) => _icon('assets/icons/serenity-guide.svg', state);

  static Widget comments([IconState state = IconState.defaultState]) => _icon('assets/icons/comments.svg', state);

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
      case 'settings':
        return settings(state);
      case 'logout':
        return logout(state);
      case 'menu':
        return menu(state);
      case 'privacy-policy':
        return privacyPolicy(state);
      case 'categories':
        return categories(state);
      case 'add':
        return add(state);
      case 'arrow-down':
        return arrowDown(state);
      case 'check':
        return check(state);
      case 'close':
        return close(state);
      case 'info':
        return info(state);
      case 'share':
        return share(state);
      case 'note-2':
        return note2(state);
      case 'send':
        return send(state);
      case 'edit':
        return edit(state);
      case 'delete':
        return delete(state);
      case 'swap':
        return swap(state);
      case 'done':
        return done(state);
      case 'info-snack':
        return infoSnack(state);
      case 'error':
        return error(state);
      case 'success':
        return success(state);
      case 'arrowDownSquare':
        return arrowDownSquare(state);
      case 'serenityGuide':
        return serenityGuide(state);
      case 'comments':
        return comments(state);
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
      case IconState.done:
        color = doneColor;
        break;
      case IconState.fail:
        color = errorColor;
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
