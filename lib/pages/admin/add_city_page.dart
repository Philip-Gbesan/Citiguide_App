import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/city_provider.dart';

class AddCityPage extends ConsumerStatefulWidget {
  const AddCityPage({super.key});

  @override
  ConsumerState<AddCityPage> createState() => _AddCityPageState();
}

class _AddCityPageState extends ConsumerState<AddCityPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitCity() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cityService = ref.read(cityServiceProvider);

      // addCity with url image
      await cityService.addCity(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City added successfully!')),
      );

      // navigate back to admin dashboard
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New City')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'City Name'),
                validator: (val) => val!.isEmpty ? 'Enter city name' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                ),
                validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
              ),
              SizedBox(height: 10),
              if (_imageUrlController.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Invalid image URL'),
                  ),
                ),
              SizedBox(height: 25),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: Icon(Icons.add_location_alt),
                label: Text('Add City'),
                onPressed: _submitCity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
