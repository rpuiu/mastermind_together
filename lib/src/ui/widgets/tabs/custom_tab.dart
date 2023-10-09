import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/tabs/tab_controller.dart';

class CustomTab extends StatelessWidget {
  final int index;
  final String title;

  const CustomTab(this.index, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final TabsController controller = Get.find();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        controller.hoverIndex.value = index;
      },
      onExit: (_) {
        controller.hoverIndex.value = -1;
      },
      child: GestureDetector(
        onTap: () {
          controller.tabIndex.value = index;
        },
        child: Obx(() {
          final bool isSelected = controller.tabIndex.value == index;
          final bool isHovered = controller.hoverIndex.value == index;
          final Color color = isSelected || isHovered ? hoverMenuIconColor : Colors.grey;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                halfSpace,
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 2,
                  width: 50,
                  color: isSelected ? hoverMenuIconColor : Colors.transparent,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
