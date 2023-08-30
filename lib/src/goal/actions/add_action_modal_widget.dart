import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/custom_modal.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

class AddActionModalWidget {
  static void show(BuildContext context, ActionController actionController, String goalId) {
    final TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    CustomModal.show(
      context: context,
      title: 'Add Action',
      children: [
        Form(
          key: formKey,
          child: CustomTextFormField(
            controller: descriptionController,
            label: 'Description',
            hintText: 'A small step you will take towards achieving your goal',
            maxLines: 3,
            maxLength: characterMaxLength,
            validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
          ),
        ),
      ],
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  actionController.createAction(goalId, descriptionController.text, 'pending');
                  Get.back();
                }
              },
              child: Text('Add', style: bodyMedium.copyWith(fontWeight: FontWeight.w700, color: hoverMenuIconColor)),
            ),
          ],
        )
      ],
    );
  }
}
