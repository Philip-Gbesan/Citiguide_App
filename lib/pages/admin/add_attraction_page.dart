import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/attraction_model.dart';
import '../../providers/city_provider.dart';
import '../../providers/category_provider.dart';

class AddAttractionPage extends ConsumerStatefulWidget {
  const AddAttractionPage({super.key});

  @override
  ConsumerState<AddAttractionPage> createState() => _AddAttractionPageState();
}

class _AddAttractionPageState extends ConsumerState<AddAttractionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCityId;
  String? _selectedCategoryId;
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(cityListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add Attraction'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select City
              citiesAsync.when(
                data: (cities) => DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select City'),
                  value: _selectedCityId,
                  items: cities
                      .map((city) => DropdownMenuItem(
                    value: city.id,
                    child: Text(city.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCityId = value),
                  validator: (value) => value == null ? 'Please select a city' : null,
                ),
                loading: () => LinearProgressIndicator(),
                error: (e, _) => Text('Error loading cities: $e'),
              ),
              SizedBox(height: 16),

              // Select Category
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Category'),
                  value: _selectedCategoryId,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategoryId = value),
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                loading: () => LinearProgressIndicator(),
                error: (e, _) => Text('Error loading categories: $e'),
              ),
              SizedBox(height: 16),

              //  Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Attraction Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description (optional)'),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              //  Phone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 16),

              //  Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),

              // Latitude & Longitude
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),

              // Opening Hours (optional)
              TextFormField(
                controller: _openingHoursController,
                decoration: InputDecoration(labelText: 'Opening Hours (optional)'),
              ),
              SizedBox(height: 16),

              // --- Website ---
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website Link'),
              ),
              SizedBox(height: 16),

              //  Date Picker (optional)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                          : 'Select a date (optional)',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              //Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 12),

              // Image Preview
              if (_imageUrlController.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      height: 180,
                      alignment: Alignment.center,
                      child: Text('Invalid image URL'),
                    ),
                  ),
                ),
              SizedBox(height: 24),

              // --- Submit Button ---
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    if (_selectedCityId == null || _selectedCategoryId == null) return;

                    setState(() => _isLoading = true);

                    final attractionId = FirebaseFirestore.instance
                        .collection('cities')
                        .doc(_selectedCityId)
                        .collection('attractions')
                        .doc()
                        .id;

                    final attraction = AttractionModel(
                      id: attractionId,
                      cityId: _selectedCityId!,
                      categoryId: _selectedCategoryId!,
                      name: _nameController.text.trim(),
                      description: _descriptionController.text.trim(),
                      phone: _phoneController.text.trim(),
                      address: _addressController.text.trim(),
                      latitude: double.tryParse(_latitudeController.text.trim()),
                      longitude: double.tryParse(_longitudeController.text.trim()),
                      openingHours: _openingHoursController.text.trim().isEmpty
                          ? null
                          : _openingHoursController.text.trim(),
                      websiteLink: _websiteController.text.trim(),
                      imageUrl: _imageUrlController.text.trim().isEmpty
                          ? null
                          : _imageUrlController.text.trim(),
                      createdAt: _selectedDate ?? DateTime.now(),
                    );

                    try {
                      await FirebaseFirestore.instance
                          .collection('cities')
                          .doc(_selectedCityId)
                          .collection('attractions')
                          .doc(attraction.id)
                          .set(attraction.toMap());

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Attraction added successfully!')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add attraction: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                  child: Text('Add Attraction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
