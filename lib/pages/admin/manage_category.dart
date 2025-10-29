import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';

class ManageCategoriesPage extends ConsumerWidget {
  const ManageCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Manage Categories')),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(child: Text('No categories available.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: (category.imageUrl?.isNotEmpty ?? false)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      category.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      Icon(Icons.image_not_supported),
                    ),
                  )
                      : Icon(Icons.category, size: 40, color: Colors.teal),
                  title: Text(category.name),
                  subtitle: (category.description?.isNotEmpty ?? false)
                      ? Text(category.description!)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showCategoryDialog(context, ref, category),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await ref
                                .read(categoryServiceProvider)
                                .deleteCategory(category.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Category deleted successfully')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Failed to delete category: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading categories: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref, null),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(
      BuildContext context, WidgetRef ref, CategoryModel? category) {
    final nameController =
    TextEditingController(text: category?.name ?? '');
    final descController =
    TextEditingController(text: category?.description ?? '');
    final imageController =
    TextEditingController(text: category?.imageUrl ?? '');
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(category == null ? 'Add Category' : 'Edit Category'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                    InputDecoration(labelText: 'Category Name'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                        labelText: 'Description (optional)'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(
                        labelText: 'Image URL (optional)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  if (nameController.text.trim().isEmpty) return;

                  setState(() => isLoading = true);

                  final categoryService =
                  ref.read(categoryServiceProvider);

                  try {
                    if (category == null) {
                      // Add new
                      await categoryService.addCategory(CategoryModel(
                        id: '',
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                        imageUrl: imageController.text.trim(),
                        createdAt: DateTime.now(),
                      ));
                    } else {
                      // Update existing
                      await categoryService.updateCategory(CategoryModel(
                        id: category.id,
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                        imageUrl: imageController.text.trim(),
                        createdAt: category.createdAt,
                      ));
                    }

                    if (context.mounted) Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(category == null
                            ? 'Category added successfully'
                            : 'Category updated successfully'),
                      ),
                    );
                  } catch (e) {
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(category == null ? 'Add' : 'Save'),
              ),
            ],
          );
        });
      },
    );
  }
}
