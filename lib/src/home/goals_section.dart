import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/goal_card.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class GoalsSection extends GetView<GoalController> {
  const GoalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text("My Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Obx(
                  () => controller.goals.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10), // Spacer
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
                  : ListView.builder(
                itemCount: controller.goals.length,
                itemBuilder: (_, index) {
                  final goal = controller.goals[index];
                  return GoalCard(goal: goal, index: index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
