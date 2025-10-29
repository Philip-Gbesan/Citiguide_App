import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/attraction_model.dart';
import '../../providers/attraction_provider.dart';
import 'edit_attraction_page.dart';

class CategoryAttractionsPage extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const CategoryAttractionsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the stream provider for attractions in this category
    final attractionsAsync = ref.watch(attractionsByCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: attractionsAsync.when(
        data: (attractions) {
          if (attractions.isEmpty) {
            return  Center(
              child: Text('No attractions found in this category.'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              final attraction = attractions[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: attraction.imageUrl != null && attraction.imageUrl!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attraction.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[300], width: 60, height: 60),
                    ),
                  )
                      : Icon(Icons.location_city, size: 40, color: Colors.teal),
                  title: Text(attraction.name),
                  subtitle: Text(attraction.address ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          // Navigate to edit page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAttractionPage(attraction: attraction),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this attraction?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await ref
                                  .read(attractionServiceProvider)
                                  .deleteAttraction(attraction.cityId, attraction.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Attraction deleted successfully!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Delete failed: $e')),
                              );
                            }
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
        error: (error, stack) => Center(child: Text('Error loading attractions: $error')),
      ),
    );
  }
}
