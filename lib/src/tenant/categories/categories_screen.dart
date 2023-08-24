import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/tenant_drawer.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class CategoriesScreen extends GetView<CategoryController> {
  final TextEditingController _newCategoryController = TextEditingController();

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _newCategoryController,
                        decoration: const InputDecoration(
                          hintText: 'New Category',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.addCategory(_newCategoryController.text);
                        _newCategoryController.clear();
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
                            IconButton(
                              icon: const Icon(Icons.edit), //TODO add edit icon
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
                            IconButton(
                              icon: const Icon(Icons.delete), //TODO add delete icon
                              onPressed: () {
                                controller.deleteCategory(category.id);
                              },
                            ),
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
