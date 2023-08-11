import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';

class AddActionsWidget extends StatelessWidget {
  final TextEditingController actionController = TextEditingController();
  final ActionController _actionController = Get.find<ActionController>();

  final String goalId;

  AddActionsWidget({Key? key, required this.goalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _actionController.fetchActionsForGoal();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: actionController,
                      decoration: const InputDecoration(
                        hintText: 'New Action',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _actionController.createAction(goalId, actionController.text, 'pending');
                      actionController.clear();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: _actionController.actions.length,
                  itemBuilder: (context, index) {
                    final action = _actionController.actions[index];
                    return ListTile(
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
                                _actionController.updateActionDescription(action.id, newDescription);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Delete logic here
                              _actionController.deleteAction(action.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editActionDialog(String currentName, BuildContext context) {
    final TextEditingController editController = TextEditingController(text: currentName);
    return AlertDialog(
      title: const Text('Edit Description'),
      content: TextFormField(
        controller: editController,
        decoration: const InputDecoration(
          hintText: 'New Action Description',
        ),
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
