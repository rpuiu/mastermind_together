import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/user_drawer.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget content;
  final bool isScrollable;
  final double desktopBreakpoint;

  const ResponsiveLayout({
    Key? key,
    required this.content,
    this.isScrollable = false,
    this.desktopBreakpoint = 800,
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
          drawer: isDesktop ? null : const CustomDrawer(),
          body: Row(
            children: [
              if (isDesktop) const CustomDrawer(),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: calculateHorizontalMargin(MediaQuery.of(context).size.width),
                        vertical: calculateVerticalMargin(MediaQuery.of(context).size.width),
                      ),
                      child: isScrollable ? SingleChildScrollView(child: content) : content,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
