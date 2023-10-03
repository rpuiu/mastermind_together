import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/delete_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/tenant_drawer.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class CategoriesScreen extends GetView<CategoryController> {
  final TextEditingController _newCategoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal & Group Categories'),
      ),
      drawer: const TenantDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(fontSize / 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _newCategoryController,
                          decoration: const InputDecoration(hintText: 'New Category'),
                          validator: (value) => FormValidators.validateEmpty(value, "Please specify a category"),
                        ),
                      ),
                      IconButton(
                        icon: AppIcons.getIcon('add', IconState.defaultState),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.addCategory(_newCategoryController.text.trim());
                            _newCategoryController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                xxSpace,
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return ListTile(
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              EditBtn(
                                onPressed: () async {
                                  final newName = await showDialog<String>(
                                    context: context,
                                    builder: (context) => _editCategoryDialog(category.name, context),
                                  );
                                  if (newName != null) {
                                    controller.updateCategory(category.id, newName);
                                  }
                                },
                              ),
                              DeleteBtn(onPressed: () => controller.deleteCategory(category.id)),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editCategoryDialog(String currentName, BuildContext context) {
    final TextEditingController editController = TextEditingController(text: currentName);
    return AlertDialog(
      title: const Text('Edit Category'),
      content: TextFormField(
        controller: editController,
        decoration: const InputDecoration(
          hintText: 'New Category Name',
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
