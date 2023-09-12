import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/base_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/responsive_padding_wrapper.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final double desktopBreakpoint;
  final bool applyPadding;

  const CustomScaffold({
    Key? key,
    required this.body,
    this.desktopBreakpoint = 800,
    this.applyPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      desktopBreakpoint: desktopBreakpoint,
      body: applyPadding ? ResponsivePaddingWrapper(child: body) : body,
    );
  }
}
