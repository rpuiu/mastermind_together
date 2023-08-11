import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/responsive_margin_wrapper.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final double desktopBreakpoint;

  const CustomScaffold({
    Key? key,
    required this.body,
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
                  foregroundColor: menuBtnColor,
                  leading: Builder(
                    builder: (BuildContext context) => IconButton(
                      icon: const Icon(Icons.menu), //TODO change icon
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
                child: SingleChildScrollView(
                  child: ResponsiveMarginWrapper(
                    child: body,
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
