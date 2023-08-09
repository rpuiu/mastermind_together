import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/color_scheme.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final int index;

  final ActionController _actionController;

  GoalCard({
    Key? key,
    required this.goal,
    required this.index,
  })  : _actionController = ActionController(goal.id),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width;
    if (cardWidth > 600) {
      cardWidth = 600;
    } else {
      cardWidth *= 0.8;
    }

    return InkWell(
      onTap: () => Get.toNamed(Routes.goalRoute(goal.id)),
      borderRadius: borderRadius,
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(fontSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildCategory(),
                _buildProgress(),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(goal.goal, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.share, color: linkColor),
          onPressed: () {
            //TODO share on pressed
          },
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(goal.category.toUpperCase(), style: labelText),
        const SizedBox(height: fontSize),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Progress:', style: labelText),
            Text('Due: ${goal.dueDate ?? ''}', style: labelText),
          ],
        ),
        const SizedBox(height: fontSize),
        const LinearProgressIndicator(value: 0.5, color: Colors.blue), // Example value
        const SizedBox(height: fontSize),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.pending_outlined, color: Colors.orange), //TODO replace with active color?
          onPressed: () {
            //TODO open actions view
          },
        ),
        Obx(() {
          if (_actionController.actions.isNotEmpty) {
            final firstAction = _actionController.actions.first;
            return Text('Priority: ${firstAction.description}', style: labelText);
          }
          return TextButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => _buildAddActionDialog(context));
            },
            child: const Text('Add Action', style: TextStyle(color: linkColor)),
          );
        }),
        IconButton(
          icon: const Icon(Icons.text_snippet_outlined, color: linkColor),
          onPressed: () {
            //TODO open actions view
          },
        ),
      ],
    );
  }

  Widget _buildAddActionDialog(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      //TODO refactor and customize AlertDialog
      title: const Text('Add Action'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              _actionController.createAction(goal.id, descriptionController.text, 'pending');
              Get.back();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
