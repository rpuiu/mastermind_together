import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/goals_section.dart';
import 'package:mastermind_together/src/home/groups_section.dart';
import 'package:mastermind_together/src/home/home_controller.dart';
import 'package:mastermind_together/src/ui/drawer.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          GoalsSection(),
          GroupsSection(),
        ],
      ),
    );
  }
}
