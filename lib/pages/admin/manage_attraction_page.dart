import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';
import 'category_attractions_page.dart';

class ManageAttractionsPage extends ConsumerWidget {
  const ManageAttractionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryService = CategoryService();

    return Scaffold(
      appBar: AppBar(title: Text('Manage Attractions')),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return Center(child: Text('No categories found.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    category.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Navigate to CategoryAttractionsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryAttractionsPage(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
