import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/app_expansion_tile_controller.dart';

class AppExpansionTile extends StatelessWidget {
  final String keyStr;
  final Widget leading;
  final Widget title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Widget? trailing;

  final Widget subtitle;

  AppExpansionTile({
    super.key,
    required this.keyStr,
    required this.leading,
    required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children: const <Widget>[],
    this.trailing,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppExpansionTileController>(
      init: AppExpansionTileController(),
      builder: (controller) {
        return ExpansionTile(
          leading: leading,
          title: title,
          backgroundColor: backgroundColor,
          initiallyExpanded: controller.isExpanded.value,
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.expand();
            } else {
              controller.collapse();
            }
            onExpansionChanged?.call(expanded);
          },
          trailing: trailing ?? const Icon(Icons.expand_more),
          children: children,
        );
      },
    );
  }
}
