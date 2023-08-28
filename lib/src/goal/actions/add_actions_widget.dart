import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/action_model.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

class AddActionsWidget extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();
  final ActionController actionController;
  final String goalId;

  AddActionsWidget({Key? key, required this.goalId, required this.actionController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    actionController.fetchActionsForGoal();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'New Action',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    actionController.createAction(goalId, textEditingController.text, 'pending');
                    textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
          xSpace,
          Container(
            height: 400, // you can adjust this height as needed
            child: Obx(() {
              return ReorderableListView.builder(
                itemCount: actionController.actions.length,
                itemBuilder: (context, index) {
                  final action = actionController.actions[index];
                  return ListTile(
                    key: ValueKey(action.id),
                    title: Text(action.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final newDescription = await showDialog<String>(
                              context: context,
                              builder: (context) => _editActionDialog(action.description, context),
                            );
                            if (newDescription != null) {
                              actionController.updateActionDescription(action.id, newDescription);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            actionController.deleteAction(action.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final ActionModel item = actionController.actions.removeAt(oldIndex);
                  actionController.actions.insert(newIndex, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _editActionDialog(String currentName, BuildContext context) {
    final TextEditingController editController = TextEditingController(text: currentName);
    return AlertDialog(
      title: const Text('Edit Description'),
      content: CustomTextFormField(
        controller: editController,
        hintText: 'E.g. Do 100 push-ups',
        label: 'New Action',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(editController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
