import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/base_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/responsive_padding_wrapper.dart';

class ScrollableCustomScaffold extends StatelessWidget {
  final Widget body;
  final double desktopBreakpoint;

  const ScrollableCustomScaffold({
    Key? key,
    required this.body,
    this.desktopBreakpoint = 800,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      desktopBreakpoint: desktopBreakpoint,
      body: SingleChildScrollView(
        child: ResponsivePaddingWrapper(child: body),
      ),
    );
  }
}
