import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/subscription/limit_alert_widget.dart';
import 'package:mastermind_together/src/subscription/subscription_controller.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/filter_chip.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/add_button.dart';

class AllGroupsScreen extends GetView<GroupController> {
  final SubscriptionController _subscriptionController = Get.find<SubscriptionController>();

  AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localContext = context;

    return CustomScaffold(
      body: Column(
        children: <Widget>[
          xHalfSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("All Groups", style: headingText),
              wHalfSpace,
              AddBtn(
                onPressed: () => _checkSubscriptionAndNavigate(context),
              )
            ],
          ),
          xHalfSpace,
          _buildFilterChips(),
          xHalfSpace,
          _buildCardGrid(context),
        ],
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      double screenWidth = MediaQuery.of(context).size.width;
      double horizontalSpacing = fontSize;
      double drawerWidth = screenWidth > 800 ? drawerMaxWidth : 0;
      double responsiveMargin = calculateHorizontalMargin(screenWidth);
      double availableWidth = screenWidth - drawerWidth - (2 * responsiveMargin);
      int numberOfColumns = ((availableWidth - horizontalSpacing) / (groupCardWidth + horizontalSpacing)).floor();

      return Flexible(
        child: ListView.builder(
          itemCount: (controller.filteredGroups.value.length / numberOfColumns).ceil(),
          itemBuilder: (context, rowIndex) {
            int start = rowIndex * numberOfColumns;
            int end = start + numberOfColumns;
            List<Widget> rowChildren = [];
            for (int index = start; index < end; index++) {
              if (index < controller.filteredGroups.value.length) {
                final group = controller.filteredGroups.value[index];
                rowChildren.add(GroupCard(group));
              }
            }
            return Row(
              mainAxisAlignment: numberOfColumns == 1 ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: rowChildren,
            );
          },
        ),
      );
    });
  }

  Obx _buildFilterChips() {
    return Obx(
      () {
        final categories = controller.categoryController.categoryNames;
        return Wrap(
          spacing: fontSize / 2,
          runSpacing: fontSize,
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

  void _checkSubscriptionAndNavigate(BuildContext context) {
    _subscriptionController.canUserCreateGroup().then((canCreate) {
      if (!canCreate) {
        showLimitReachedAlert(context);
        return;
      }
      Get.toNamed(Routes.createGroup);
    });
  }
}
