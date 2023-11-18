import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/home/sections/goals_section.dart';
import 'package:mastermind_together/src/home/sections/my_groups_section.dart';
import 'package:mastermind_together/src/ui/theme/layout/scrollable_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableCustomLayout(content: _buildMainContent());
  }

  Column _buildMainContent() {
    return Column(
      children: [
        xxxxSpace,
         GoalsSection(),
        xxxxSpace,
        const MyGroupsSection(),
        xxxxSpace,
      ],
    );
  }
}
