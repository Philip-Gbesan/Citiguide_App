// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/city_provider.dart';
//
// class AddCityPage extends ConsumerStatefulWidget {
//   const AddCityPage({super.key});
//
//   @override
//   ConsumerState<AddCityPage> createState() => _AddCityPageState();
// }
//
// class _AddCityPageState extends ConsumerState<AddCityPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descController = TextEditingController();
//   final _imageUrlController = TextEditingController();
//   bool _isLoading = false;
//
//   Future<void> _submitCity() async {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final cityService = ref.read(cityServiceProvider);
//
//       // addCity with url image
//       await cityService.addCity(
//         name: _nameController.text.trim(),
//         description: _descController.text.trim(),
//         imageUrl: _imageUrlController.text.trim(),
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('City added successfully!')),
//       );
//
//       // navigate back to admin dashboard
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add New City')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'City Name'),
//                 validator: (val) => val!.isEmpty ? 'Enter city name' : null,
//               ),
//               SizedBox(height: 15),
//               TextFormField(
//                 controller: _descController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (val) => val!.isEmpty ? 'Enter description' : null,
//               ),
//               SizedBox(height: 15),
//               TextFormField(
//                 controller: _imageUrlController,
//                 decoration: InputDecoration(
//                   labelText: 'Image URL',
//                   hintText: 'https://example.com/image.jpg',
//                 ),
//                 validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
//               ),
//               SizedBox(height: 10),
//               if (_imageUrlController.text.isNotEmpty)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Image.network(
//                     _imageUrlController.text,
//                     height: 150,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                     Text('Invalid image URL'),
//                   ),
//                 ),
//               SizedBox(height: 25),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 icon: Icon(Icons.add_location_alt),
//                 label: Text('Add City'),
//                 onPressed: _submitCity,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import '../../models/city_model.dart';
// import '../../services/city_service.dart';
//
// class AdminCitiesScreen extends StatelessWidget {
//   final CityService _cityService = CityService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: Column(
//         children: [
//           // Header Section
//           Container(
//             padding: EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'CURRENT CITIES GUIDE',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[600],
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     _buildTabChip('Cities', true),
//                     SizedBox(width: 8),
//                     _buildTabChip('Attractions', false),
//                     SizedBox(width: 8),
//                     _buildTabChip('Restaurants', false),
//                     SizedBox(width: 8),
//                     _buildTabChip('Events', false),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Cities Grid
//           Expanded(
//             child: StreamBuilder<List<CityModel>>(
//               stream: _cityService.getCitiesStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.location_city, size: 80, color: Colors.grey[300]),
//                         SizedBox(height: 16),
//                         Text(
//                           'No cities yet',
//                           style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 final cities = snapshot.data!;
//
//                 return GridView.builder(
//                   padding: EdgeInsets.all(16),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.75,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                   ),
//                   itemCount: cities.length,
//                   itemBuilder: (context, index) {
//                     return _buildCityCard(context, cities[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//
//       // Add City Button
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => Navigator.pushNamed(context, '/addCity'),
//         backgroundColor: Color(0xFF1976D2),
//         icon: Icon(Icons.add, color: Colors.white),
//         label: Text(
//           'Add city guide',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   Widget _buildTabChip(String label, bool isSelected) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isSelected ? Color(0xFF1976D2) : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isSelected ? Color(0xFF1976D2) : Colors.grey[300]!,
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.grey[700],
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCityCard(BuildContext context, CityModel city) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to city details/edit
//         Navigator.pushNamed(context, '/editCity', arguments: city);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // City Image
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.network(
//                 city.imageUrl,
//                 height: 120,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     height: 120,
//                     color: Colors.grey[300],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.location_city, size: 40, color: Colors.grey[400]),
//                         SizedBox(height: 4),
//                         Text(
//                           city.name,
//                           style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // City Info
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     city.name,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           city.country,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       _buildActionButton(
//                         Icons.edit,
//                             () {
//                           Navigator.pushNamed(context, '/editCity', arguments: city);
//                         },
//                       ),
//                       SizedBox(width: 8),
//                       _buildActionButton(
//                         Icons.delete,
//                             () {
//                           _showDeleteDialog(context, city);
//                         },
//                         color: Colors.red[400],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, VoidCallback onTap, {Color? color}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: (color ?? Color(0xFF1976D2)).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Icon(icon, size: 16, color: color ?? Color(0xFF1976D2)),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(BuildContext context, CityModel city) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete City'),
//         content: Text('Are you sure you want to delete "${city.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await _cityService.deleteCity(city.id);
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('City deleted')),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import '../../models/city_model.dart';
import '../../services/city_service.dart';

class AdminCitiesScreen extends StatelessWidget {
  final CityService _cityService = CityService();

  AdminCitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT CITIES GUIDE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildTabChip('Cities', true),
                    SizedBox(width: 8),
                    _buildTabChip('Attractions', false),
                    SizedBox(width: 8),
                    _buildTabChip('Restaurants', false),
                    SizedBox(width: 8),
                    _buildTabChip('Events', false),
                  ],
                ),
              ],
            ),
          ),

          // Cities Grid
          Expanded(
            child: StreamBuilder<List<CityModel>>(
              stream: _cityService.getCitiesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_city, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          'No cities yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                final cities = snapshot.data!;

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return _buildCityCard(context, cities[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Add City Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/addCity'),
        backgroundColor: Color(0xFF1976D2),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add city guide',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTabChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF1976D2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Color(0xFF1976D2) : Colors.grey[300]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCityCard(BuildContext context, CityModel city) {
    return GestureDetector(
      onTap: () {
        // Navigate to city details/edit
        Navigator.pushNamed(context, '/editCity', arguments: city);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                city.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_city, size: 40, color: Colors.grey[400]),
                        SizedBox(height: 4),
                        Text(
                          city.name,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // City Info
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Removed country reference - replace with description or remove this section
                  Text(
                    city.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        Icons.edit,
                            () {
                          Navigator.pushNamed(context, '/editCity', arguments: city);
                        },
                      ),
                      SizedBox(width: 8),
                      _buildActionButton(
                        Icons.delete,
                            () {
                          _showDeleteDialog(context, city);
                        },
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (color ?? Color(0xFF1976D2)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color ?? Color(0xFF1976D2)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CityModel city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete City'),
        content: Text('Are you sure you want to delete "${city.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _cityService.deleteCity(city.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('City deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
