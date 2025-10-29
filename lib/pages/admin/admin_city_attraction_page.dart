import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/attraction_model.dart';
import '../../providers/attraction_provider.dart';

class AdminCityAttractionsPage extends ConsumerWidget {
  final String cityId;
  final String cityName;

  const AdminCityAttractionsPage({
    super.key,
    required this.cityId,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractionStream = ref.watch(cityAttractionsProvider(cityId));

    return Scaffold(
      appBar: AppBar(title: Text('$cityName Attractions')),
      body: attractionStream.when(
        data: (attractions) {
          if (attractions.isEmpty) {
            return Center(child: Text('No attractions yet.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              final attr = attractions[index];

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: attr.imageUrl != null && attr.imageUrl!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attr.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      Icon(Icons.image_not_supported),
                    ),
                  )
                      : Icon(Icons.location_city, size: 40, color: Colors.teal),
                  title: Text(attr.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((attr.description?.isNotEmpty ?? false))
                        Text(attr.description!,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      if (attr.address != null)
                        Text('📍 ${attr.address}',
                            style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (attr.phone != null)
                        Text('📞 ${attr.phone}',
                            style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (attr.openingHours != null)
                        Text('⏰ ${attr.openingHours}',
                            style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (attr.websiteLink != null)
                        Text('🔗 ${attr.websiteLink}',
                            style:
                            TextStyle(fontSize: 12, color: Colors.blue)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () =>
                            _editAttractionDialog(context, ref, attr),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await ref
                                .read(attractionServiceProvider)
                                .deleteAttraction(cityId, attr.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Attraction deleted successfully!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Delete failed: $e')),
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
        error: (e, _) => Center(child: Text('Error loading attractions: $e')),
      ),
    );
  }

  Future<void> _editAttractionDialog(
      BuildContext context, WidgetRef ref, AttractionModel attr) async {
    final nameController = TextEditingController(text: attr.name);
    final descController = TextEditingController(text: attr.description);
    final phoneController = TextEditingController(text: attr.phone ?? '');
    final imageController = TextEditingController(text: attr.imageUrl ?? '');
    final addressController = TextEditingController(text: attr.address ?? '');
    final latController =
    TextEditingController(text: attr.latitude?.toString() ?? '');
    final lngController =
    TextEditingController(text: attr.longitude?.toString() ?? '');
    final openingController =
    TextEditingController(text: attr.openingHours ?? '');
    final websiteController =
    TextEditingController(text: attr.websiteLink ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Attraction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description')),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone')),
              TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Image URL')),
              TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address')),
              TextField(
                  controller: latController,
                  decoration: InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: lngController,
                  decoration: InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: openingController,
                  decoration: InputDecoration(labelText: 'Opening Hours')),
              TextField(
                  controller: websiteController,
                  decoration: InputDecoration(labelText: 'Website Link')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedAttr = attr.copyWith(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  phone: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                  imageUrl: imageController.text.trim().isEmpty
                      ? null
                      : imageController.text.trim(),
                  address: addressController.text.trim().isEmpty
                      ? null
                      : addressController.text.trim(),
                  latitude: latController.text.trim().isEmpty
                      ? null
                      : double.tryParse(latController.text.trim()),
                  longitude: lngController.text.trim().isEmpty
                      ? null
                      : double.tryParse(lngController.text.trim()),
                  openingHours: openingController.text.trim().isEmpty
                      ? null
                      : openingController.text.trim(),
                  websiteLink: websiteController.text.trim().isEmpty
                      ? null
                      : websiteController.text.trim(),
                );

                await ref
                    .read(attractionServiceProvider)
                    .updateAttraction(updatedAttr);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attraction updated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed: $e')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
