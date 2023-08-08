import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/groups/group_card_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/home/goals_carousel_controller.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

import 'goals_carousel_widget.dart';

class HomeScreen extends GetView<HomeController> {
  final AuthController authController = Get.find<AuthController>();
  final GoalController goalController = Get.find<GoalController>();
  final GroupController groupController = Get.find<GroupController>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width ;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          Column(
            children: [
              const SizedBox(height: 8),
              const Text("My Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: containerWidth,
                child: MyGoalsSection(goalController: goalController),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text("My Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          MyGroupsSection(groupController: groupController),
          const SizedBox(height: 10),
          const Text("Matching Groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          MatchingGroupsSection(goalController: goalController, groupController: groupController),
        ],
      ),
    );
  }
}

class MatchingGroupsSection extends StatelessWidget {
  const MatchingGroupsSection({
    super.key,
    required this.goalController,
    required this.groupController,
  });

  final GoalController goalController;
  final GroupController groupController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<GoalModel> userGoals = goalController.goals.value;
      if (userGoals.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please set a goal in order to view matching groups.'),
            CustomButton(
              onPressed: () {
                Get.toNamed(Routes.createGoal);
              },
              child: const Text('Set a Goal'),
            ),
          ],
        );
      } else if (groupController.matchingGroups.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No matching groups found.'),
            CustomButton(
              onPressed: () {
                Get.toNamed(Routes.createGroup);
              },
              child: const Text('Create new group'),
            ),
            const SizedBox(height: 10),
            groupController.sameCategoryGroups.isEmpty
                ? Container()
                : const Text("Available groups in the same category:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: groupController.sameCategoryGroups.length,
              itemBuilder: (context, index) {
                final group = groupController.sameCategoryGroups[index];
                return GroupCard(group: group);
              },
            ),
          ],
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupController.matchingGroups.length,
          itemBuilder: (context, index) {
            final group = groupController.matchingGroups[index];
            return GroupCard(group: group);
          },
        );
      }
    });
  }
}

class MyGroupsSection extends StatelessWidget {
  const MyGroupsSection({
    super.key,
    required this.groupController,
  });

  final GroupController groupController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (groupController.userGroups.isEmpty) {
        return const Center(child: Text('No groups yet.'));
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupController.userGroups.length,
          itemBuilder: (context, index) {
            final group = groupController.userGroups[index];
            return GroupCard(group: group);
          },
        );
      }
    });
  }
}

class MyGoalsSection extends StatelessWidget {
  const MyGoalsSection({
    super.key,
    required this.goalController,
  });

  final GoalController goalController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Obx(
        () => goalController.goals.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text('You haven\'t set any goals yet.'),
                    CustomButton(
                      onPressed: () {
                        Get.toNamed(Routes.createGoal);
                      },
                      child: const Text('Set a Goal'),
                    ),
                  ],
                ),
              )
            : AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: Get.find<GoalsCarouselController>().height.value, // Reactive height
                child: GoalsCarousel(goals: goalController.goals),
              ),
      ),
    );
  }
}
