import 'package:flutter/material.dart';

import '../../models/city_model.dart';
import '../../services/city_service.dart';
import '../../services/restaurant_service.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({Key? key}) : super(key: key);

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  final RestaurantService _restaurantService = RestaurantService();
  final CityService _cityService = CityService();

  CityModel? _selectedCity;
  String _selectedCuisine = 'Italian';
  String _selectedPriceRange = '\$\$';
  List<String> _specialties = [];
  final _specialtyController = TextEditingController();
  bool _isLoading = false;

  final List<String> _cuisineTypes = [
    'Italian',
    'Chinese',
    'Mexican',
    'Japanese',
    'American',
    'French',
    'Indian',
    'Thai',
    'Mediterranean',
    'Korean',
  ];

  final List<String> _priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  Future<void> _submitRestaurant() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_selectedCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a city')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final contactInfo = {
        if (_phoneController.text.isNotEmpty)
          'phone': _phoneController.text.trim(),
        if (_emailController.text.isNotEmpty)
          'email': _emailController.text.trim(),
        if (_websiteController.text.isNotEmpty)
          'website': _websiteController.text.trim(),
      };

      await _restaurantService.addRestaurant(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        cityId: _selectedCity!.id,
        cityName: _selectedCity!.name,
        address: _addressController.text.trim(),
        cuisine: _selectedCuisine,
        priceRange: _selectedPriceRange,
        specialties: _specialties,
        contactInfo: contactInfo,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Restaurant added successfully!')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addSpecialty() {
    if (_specialtyController.text.isNotEmpty) {
      setState(() {
        _specialties.add(_specialtyController.text.trim());
        _specialtyController.clear();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Restaurant'),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restaurant Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Restaurant Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Enter restaurant name' : null,
              ),
              SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/image.jpg',
                ),
                validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
              ),
              if (_imageUrlController.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _imageUrlController.text,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: Center(child: Text('Invalid image URL')),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16),

              // City Selection
              StreamBuilder<List<CityModel>>(
                stream: _cityService.getCitiesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final cities = snapshot.data!;

                  return DropdownButtonFormField<CityModel>(
                    decoration: InputDecoration(
                      labelText: 'City *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    value: _selectedCity,
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: (city) {
                      setState(() {
                        _selectedCity = city;
                      });
                    },
                    validator: (val) => val == null ? 'Select a city' : null,
                  );
                },
              ),
              SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (val) => val!.isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 16),

              // Cuisine Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Cuisine Type *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                value: _selectedCuisine,
                items: _cuisineTypes.map((cuisine) {
                  return DropdownMenuItem(value: cuisine, child: Text(cuisine));
                }).toList(),
                onChanged: (cuisine) {
                  setState(() {
                    _selectedCuisine = cuisine!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Price Range
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Price Range *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                value: _selectedPriceRange,
                items: _priceRanges.map((price) {
                  return DropdownMenuItem(value: price, child: Text(price));
                }).toList(),
                onChanged: (price) {
                  setState(() {
                    _selectedPriceRange = price!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Specialties
              Text(
                'Specialties',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _specialtyController,
                      decoration: InputDecoration(
                        hintText: 'Add a specialty',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addSpecialty,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              if (_specialties.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    children: _specialties.map((specialty) {
                      return Chip(
                        label: Text(specialty),
                        onDeleted: () {
                          setState(() {
                            _specialties.remove(specialty);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 16),

              // Contact Information
              Text(
                'Contact Information (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: Icon(Icons.add_business),
                      label: Text('Add Restaurant'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _submitRestaurant,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
