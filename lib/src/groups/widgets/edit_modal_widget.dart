import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/widgets/custom_modal.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

class EditModal extends StatelessWidget {
  final String title;
  final String label;
  final String hintText;
  final String initialValue;
  final Function(String) onSave;

  const EditModal({
    super.key,
    required this.title,
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onSave,
  });

  static void show({
    required BuildContext context,
    required String title,
    required String label,
    required String hintText,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final TextEditingController controller = TextEditingController(text: initialValue);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    CustomModal.show(
      context: context,
      title: title,
      children: [
        Form(
          key: formKey,
          child: CustomTextFormField(
            controller: controller,
            label: label,
            hintText: hintText,
            maxLines: 1,
            validator: (value) => value?.isEmpty == true ? '$label cannot be empty' : null,
          ),
        ),
      ],
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  onSave(controller.text);
                  Get.back();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This can be empty as we're using the static show method to display the widget.
    return const SizedBox.shrink();
  }
}
