import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/home/sections/goals_section.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/home/sections/my_groups_section.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/scrollable_custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableCustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 4 * fontSize),
          const GoalsSection(),
          const SizedBox(height: 4 * fontSize),
          const MyGroupsSection(),
          const SizedBox(height: 4 * fontSize),
          MatchingGroupsSection(),
          const SizedBox(height: 4 * fontSize),
        ],
      ),
    );
  }
}
