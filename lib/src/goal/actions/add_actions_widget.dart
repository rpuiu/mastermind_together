import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/action_model.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_editing_controller.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/add_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/close_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/delete_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/done_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/reorder_button.dart';
import 'package:mastermind_together/src/ui/widgets/input/underline_text_form_field.dart';

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
            Expanded(
                child: CustomUnderlineTextField(
              textEditingController: textEditingController,
              hintText: 'New Action',
              emptyValidationMsg: 'Please add a new action',
            )),
            AddBtn(onPressed: () {
              if (_formKey.currentState!.validate()) {
                actionController.createAction(goalId, textEditingController.text, 'pending');
                textEditingController.clear();
              }
            }),
          ],
        ),
      ),
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
          onReorder: (oldIndex, newIndex) => actionController.reorderActions(oldIndex, newIndex),
        );
      }),
    );
  }

  Widget _buildActionListItem(BuildContext context, int index) {
    final ActionModel action = actionController.actions[index];
    final TextEditingController editController = TextEditingController(text: action.description);

    return KeyedSubtree(
      key: ValueKey(action.id),
      child: Card(
        elevation: 2,
        child: ListTile(
          onTap: () => this.editController.toggleEditing(action.id),
          title: Obx(() => _buildEditableTitle(action, editController, index)),
          tileColor: index == 0 ? activeMenuIconColor.withOpacity(0.6) : null,
          leading: ReorderBtn(index: actionController.actions.indexOf(action)),
          trailing: _buildActionItemTrailing(context, action, editController),
        ),
      ),
    );
  }

  Widget _buildEditableTitle(ActionModel action, TextEditingController editController, int index) {
    if (this.editController.isEditing(action.id)) {
      return CustomEditTextField(
        editController: editController,
        onEditingComplete: () {
          actionController.updateActionDescription(action.id, editController.text);
          this.editController.toggleEditing(action.id);
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(action.description, style: index == 0 ? bodyMedium : null),
      );
    }
  }

  Widget _buildActionItemTrailing(BuildContext context, ActionModel action, TextEditingController editController) {
    return Obx(() {
      if (this.editController.isEditing(action.id)) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DoneBtn(
              onPressed: () {
                actionController.updateListWithActionDescription(action.id, editController.text);
                actionController.updateActionDescription(action.id, editController.text);
                this.editController.toggleEditing(action.id);
              },
            ),
            CloseBtn(
              onPressed: () => this.editController.toggleEditing(action.id),
              iconState: IconState.fail,
            ),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EditBtn(onPressed: () => this.editController.toggleEditing(action.id)),
            DeleteBtn(onPressed: () => actionController.deleteAction(action.id)),
          ],
        );
      }
    });
  }
}
