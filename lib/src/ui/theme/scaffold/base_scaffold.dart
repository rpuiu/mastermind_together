import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/user_drawer.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final double desktopBreakpoint;

  const BaseScaffold({
    Key? key,
    required this.body,
    required this.desktopBreakpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isDesktop = constraints.maxWidth > desktopBreakpoint;

        return Scaffold(
          appBar: !isDesktop
              ? AppBar(
                  backgroundColor: drawerBgColor,
                  foregroundColor: hoverMenuTextColor,
                  leading: Builder(
                    builder: (BuildContext context) => IconButton(
                      icon: AppIcons.getIcon('menu', IconState.activeState),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                )
              : null,
          drawer: isDesktop ? null : CustomDrawer(),
          body: Row(
            children: [
              if (isDesktop) CustomDrawer(),
              Flexible(
                fit: FlexFit.loose,
                child: body,
              ),
            ],
          ),
        );
      },
    );
  }
}
