import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomExpansionTile extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    required this.initiallyExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(

          /// Prevents to splash effect when clicking.
          splashColor: Colors.transparent,

          /// Prevents the mouse cursor to highlight the tile when hovering on web.
          hoverColor: Colors.transparent,

          /// Hides the highlight color when the tile is pressed.
          highlightColor: Colors.transparent,

          /// Makes the top and bottom dividers invisible when expanded.
          dividerColor: Colors.transparent,
          expansionTileTheme: expansionTileTheme),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: title,
        children: children,
      ),
    );
  }
}

ExpansionTileThemeData expansionTileTheme = ExpansionTileThemeData(
  backgroundColor: Colors.transparent,
  collapsedBackgroundColor: Colors.transparent,
  iconColor: hoverMenuIconColor,
  collapsedIconColor: hoverMenuIconColor,
  tilePadding: const EdgeInsets.only(top: fontSize / 2, left: fontSize, right: fontSize, bottom: fontSize / 2),
  childrenPadding: const EdgeInsets.only(left: fontSize, right: fontSize, bottom: fontSize),
  shape: RoundedRectangleBorder(borderRadius: borderRadius),
  collapsedShape: RoundedRectangleBorder(borderRadius: borderRadius),
);
