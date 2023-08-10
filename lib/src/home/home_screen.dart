import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/home/sections/goals_section.dart';
import 'package:mastermind_together/src/home/sections/matching_groups_section.dart';
import 'package:mastermind_together/src/home/sections/my_groups_section.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/responsive_margin_wrapper.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: ResponsiveMarginWrapper(
          child: Column(
            children: [
              const GoalsSection(),
              const SizedBox(height: 4 * fontSize),
              const MyGroupsSection(),
              const SizedBox(height: 4 * fontSize),
              MatchingGroupsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
