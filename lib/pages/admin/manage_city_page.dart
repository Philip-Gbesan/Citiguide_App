import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/city_model.dart';
import '../../providers/city_provider.dart';
import 'edit_city_page.dart';

class ManageCityPage extends ConsumerWidget {
  const ManageCityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(cityListProvider);

    void _confirmDelete(BuildContext context, String cityId, WidgetRef ref) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this city?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final cityService = ref.read(cityServiceProvider);
                  await cityService.deleteCity(cityId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('City deleted successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete city: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Cities'),
      ),
      body: citiesAsync.when(
        data: (cities) {
          if (cities.isEmpty) {
            return Center(
              child: Text('No cities added yet'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: (city.imageUrl ?? '').isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      city.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      Icon(Icons.image_not_supported),
                    ),
                  )
                      : Icon(Icons.location_city, size: 40, color: Colors.teal),
                  title: Text(
                    city.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: (city.description ?? '').isNotEmpty
                      ? Text(
                    city.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                      : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditCityPage(city: city),
                          ),
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(context, city.id, ref);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading cities: $e')),
      ),
    );
  }
}
