import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class AllGroupsScreen extends GetView<GroupController> {
  const AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Groups'),
      ),
      drawer: CustomDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Obx(
              () {
                final categories = controller.categoryController.categoryNames;
                return Wrap(
                  spacing: 5.0,
                  children: categories.map((String category) {
                    return FilterChip(
                      label: Text(category),
                      selected: controller.selectedCategories.contains(category),
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
            ),
            const SizedBox(height: 2 * fontSize),
            CustomButton(
              onPressed: () {
                Get.toNamed(Routes.createGroup);
              },
              child: const Text('Create New Group'),
            ),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Row(
                    children: List.generate(controller.filteredGroups.value.length, (index) {
                      final group = controller.filteredGroups.value[index];
                      return GroupCard(group);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
