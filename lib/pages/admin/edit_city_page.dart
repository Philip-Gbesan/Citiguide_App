import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/city_provider.dart';
import '../../models/city_model.dart';

class EditCityPage extends ConsumerStatefulWidget {
  final CityModel city;

  const EditCityPage({super.key, required this.city});

  @override
  ConsumerState<EditCityPage> createState() => _EditCityPageState();
}

class _EditCityPageState extends ConsumerState<EditCityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _imageUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.city.name);
    _descController = TextEditingController(text: widget.city.description ?? '');
    _imageUrlController = TextEditingController(text: widget.city.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateCity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cityService = ref.read(cityServiceProvider);

      await cityService.updateCity(
        cityId: widget.city.id,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating city: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit City')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'City Name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter city name' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                ),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 15),
              if (_imageUrlController.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      height: 180,
                      alignment: Alignment.center,
                      child: Text('Invalid image URL'),
                    ),
                  ),
                ),
              SizedBox(height: 25),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Save Changes'),
                onPressed: _updateCity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
