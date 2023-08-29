import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';

class ReorderBtn extends StatelessWidget {
  final int index;

  const ReorderBtn({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: AppIcons.getIcon('swap', IconState.defaultState),
    );
  }
}
