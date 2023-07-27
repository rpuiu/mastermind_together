import 'package:flutter/material.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final int index;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          '${index + 1}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        title: Text(
          '${goal.goal}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Category: ${goal.category}'),
      ),
    );
  }
}
