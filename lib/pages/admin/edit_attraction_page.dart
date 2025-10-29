import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/attraction_model.dart';
import '../../providers/attraction_provider.dart';

class EditAttractionPage extends ConsumerStatefulWidget {
  final AttractionModel attraction;

  const EditAttractionPage({super.key, required this.attraction});

  @override
  ConsumerState<EditAttractionPage> createState() => _EditAttractionPageState();
}

class _EditAttractionPageState extends ConsumerState<EditAttractionPage> {
  late final TextEditingController nameController;
  late final TextEditingController descController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  late final TextEditingController imageController;
  late final TextEditingController latController;
  late final TextEditingController lngController;
  late final TextEditingController openingController;
  late final TextEditingController websiteController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.attraction.name);
    descController = TextEditingController(text: widget.attraction.description);
    addressController = TextEditingController(text: widget.attraction.address);
    phoneController = TextEditingController(text: widget.attraction.phone);
    imageController = TextEditingController(text: widget.attraction.imageUrl);
    latController = TextEditingController(text: widget.attraction.latitude?.toString());
    lngController = TextEditingController(text: widget.attraction.longitude?.toString());
    openingController = TextEditingController(text: widget.attraction.openingHours);
    websiteController = TextEditingController(text: widget.attraction.websiteLink);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    addressController.dispose();
    phoneController.dispose();
    imageController.dispose();
    latController.dispose();
    lngController.dispose();
    openingController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Attraction')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(nameController, 'Name'),
            _buildTextField(descController, 'Description'),
            _buildTextField(addressController, 'Address'),
            _buildTextField(phoneController, 'Phone'),
            _buildTextField(imageController, 'Image URL'),
            _buildTextField(latController, 'Latitude', keyboard: TextInputType.number),
            _buildTextField(lngController, 'Longitude', keyboard: TextInputType.number),
            _buildTextField(openingController, 'Opening Hours'),
            _buildTextField(websiteController, 'Website Link'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Save'),
                onPressed: _saveAttraction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _saveAttraction() async {
    try {
      final updatedAttr = widget.attraction.copyWith(
        name: nameController.text.trim(),
        description: descController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        imageUrl: imageController.text.trim().isEmpty ? null : imageController.text.trim(),
        latitude: latController.text.trim().isEmpty
            ? null
            : double.tryParse(latController.text.trim()),
        longitude: lngController.text.trim().isEmpty
            ? null
            : double.tryParse(lngController.text.trim()),
        openingHours: openingController.text.trim().isEmpty ? null : openingController.text.trim(),
        websiteLink: websiteController.text.trim().isEmpty ? null : websiteController.text.trim(),
      );

      await ref.read(attractionServiceProvider).updateAttraction(updatedAttr);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attraction updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }
}
