import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/filter_chip.dart';

class AllGroupsScreen extends GetView<GroupController> {
  const AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 1.5 * fontSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("All Groups", style: headingText),
              const SizedBox(width: 1.5 * fontSize),
              _buildCreateGroupBtn(),
            ],
          ),
          const SizedBox(height: 1.5 * fontSize),
          _buildFilterChips(),
          const SizedBox(height: 1.5 * fontSize),
          _buildCardGrid(context),
        ],
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        double screenWidth = MediaQuery.of(context).size.width;
        double horizontalSpacing = fontSize;
        double drawerWidth = screenWidth > 800 ? drawerMaxWidth : 0;
        double responsiveMargin = calculateHorizontalMargin(screenWidth);
        double availableWidth = screenWidth - drawerWidth - (2 * responsiveMargin);

        int numberOfColumns = ((availableWidth - horizontalSpacing) / (groupCardWidth + horizontalSpacing)).floor();

        List<Widget> rows = [];
        for (int i = 0; i < controller.filteredGroups.value.length; i += numberOfColumns) {
          List<Widget> rowChildren = [];
          for (int j = 0; j < numberOfColumns; j++) {
            int index = i + j;
            if (index < controller.filteredGroups.value.length) {
              final group = controller.filteredGroups.value[index];
              rowChildren.add(GroupCard(group));
            }
          }
          rows.add(
            Row(
              mainAxisAlignment: numberOfColumns == 1
                  ? MainAxisAlignment.center // Center the children if there's only one column
                  : MainAxisAlignment.start, // Otherwise, align to the start
              children: rowChildren,
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }

  CustomButton _buildCreateGroupBtn() {
    return CustomButton(
      onPressed: () {
        Get.toNamed(Routes.createGroup);
      },
      child: const Text('Create New'),
    );
  }

  Obx _buildFilterChips() {
    return Obx(
      () {
        final categories = controller.categoryController.categoryNames;
        return Wrap(
          spacing: fontSize / 2,
          children: categories.map((String category) {
            return CustomFilterChip(
              category: category,
              isSelected: controller.selectedCategories.contains(category),
              onSelected: (bool selected) {
                if (selected) {
                  controller.selectedCategories.add(category);
                } else {
                  controller.selectedCategories.remove(category);
                }
                controller.filterGroupsByCategory(controller.selectedCategories.toList());
              },
            );
          }).toList(),
        );
      },
    );
  }
}
