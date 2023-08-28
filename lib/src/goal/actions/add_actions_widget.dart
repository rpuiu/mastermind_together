import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/action_model.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_editing_controller.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class AddActionsWidget extends StatelessWidget {
  final ActionEditController editController = Get.find<ActionEditController>();

  final TextEditingController textEditingController = TextEditingController();
  final ActionController actionController;
  final String goalId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddActionsWidget({Key? key, required this.goalId, required this.actionController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    actionController.fetchActionsForGoal();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildActionInputField(),
          xxxSpace,
          _buildReorderableActionList(),
        ],
      ),
    );
  }

  Widget _buildActionInputField() {
    return Padding(
      padding: const EdgeInsets.all(fontSize / 2),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(child: _buildTextField()),
            _buildAddActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: 'New Action',
        hintStyle: formHintTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: hoverMenuIconColor, width: 2.0),
        ),
      ),
      validator: (value) => FormValidators.validateEmpty(value, "Please add a new action"),
    );
  }

  Widget _buildAddActionButton() {
    return IconButton(
      icon: AppIcons.getIcon('add', IconState.hoverState),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          actionController.createAction(goalId, textEditingController.text, 'pending');
          textEditingController.clear();
        }
      },
    );
  }

  Widget _buildReorderableActionList() {
    return SizedBox(
      height: 400,
      child: Obx(() {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: actionController.actions.length,
          itemBuilder: (context, index) => _buildActionListItem(context, index),
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) newIndex -= 1;
            final ActionModel item = actionController.actions.removeAt(oldIndex);
            actionController.actions.insert(newIndex, item);
            actionController.updateRanksAfterReorder();
          },
        );
      }),
    );
  }

  Widget _buildActionListItem(BuildContext context, int index) {
    final action = actionController.actions[index];
    // Create a controller or reuse if already created
    final editController = TextEditingController(text: action.description);

    return KeyedSubtree(
      key: ValueKey(action.id),
      child: Card(
        elevation: 2,
        child: ListTile(
          onTap: () => this.editController.toggleEditing(action.id),
          title: Obx(() {
            if (this.editController.isEditing(action.id)) {
              return TextField(
                maxLines: 3,
                minLines: 1,
                controller: editController,
                onEditingComplete: () {
                  actionController.updateActionDescription(action.id, editController.text);
                  this.editController.toggleEditing(action.id);
                },
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  action.description,
                  style: index == 0 ? bodyMedium : null,
                ),
              );
            }
          }),
          tileColor: index == 0 ? doneColor.withOpacity(0.2) : null,
          leading: ReorderableDragStartListener(
            index: actionController.actions.indexOf(action),
            child: AppIcons.getIcon('swap', IconState.defaultState),
          ),
          trailing: _buildActionItemTrailing(context, action, editController),
        ),
      ),
    );
  }

  Widget _buildActionItemTrailing(BuildContext context, ActionModel action, TextEditingController editController) {
    return Obx(() {
      if (this.editController.isEditing(action.id)) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: AppIcons.getIcon('done', IconState.done),
              onPressed: () {
                actionController.updateListWithActionDescription(action.id, editController.text);
                actionController.updateActionDescription(action.id, editController.text);
                this.editController.toggleEditing(action.id);
              },
            ),
            IconButton(
              icon: AppIcons.getIcon('close', IconState.fail),
              onPressed: () {
                this.editController.toggleEditing(action.id);
              },
            ),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: AppIcons.getIcon('edit', IconState.defaultState),
              onPressed: () {
                this.editController.toggleEditing(action.id);
              },
            ),
            IconButton(
              icon: AppIcons.getIcon('delete', IconState.defaultState),
              onPressed: () {
                actionController.deleteAction(action.id);
              },
            ),
          ],
        );
      }
    });
  }
}
