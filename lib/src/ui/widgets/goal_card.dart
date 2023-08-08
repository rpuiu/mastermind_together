import 'package:flutter/material.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goalModel;
  final List<String> keyResults;
  final Function(bool, dynamic) onExpansionChanged;

  GoalCard({super.key, required this.goalModel, required this.keyResults, required this.onExpansionChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    goalModel.goal,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO Share logic here
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  goalModel.category.toUpperCase(),
                  style: labelText,
                ),
                const Spacer(),
                // const Icon(Icons.date_range),
                // const SizedBox(width: 8),
                // Text('Start Date: ${goalModel.createdAt.day}/${goalModel.createdAt.month}/${goalModel.createdAt.year}'),
              ],
            ),
            const SizedBox(height: 24),
            ExpansionTile(
              onExpansionChanged: (expanded) => onExpansionChanged(expanded, keyResults.length),
              title: const Text('Actions:'),
              subtitle: LinearProgressIndicator(
                value: 1 / keyResults.length, //TODO calculate progress once key results are up.
                backgroundColor: Colors.grey[300],
              ),
              children: [
                Column(
                  children: keyResults.map((keyResult) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(keyResult)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
