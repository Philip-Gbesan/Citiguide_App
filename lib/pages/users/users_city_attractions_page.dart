import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'users_category_attractions_page.dart';

class UsersCityAttractionsPage extends StatelessWidget {
  final String cityId;
  final String cityName;

  const UsersCityAttractionsPage({
    super.key,
    required this.cityId,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    final cityRef = FirebaseFirestore.instance.collection('cities').doc(cityId);
    final categoriesRef = FirebaseFirestore.instance.collection('categories');

    return Scaffold(
      appBar: AppBar(title: Text('$cityName Attractions')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: cityRef.snapshots(),
        builder: (context, citySnapshot) {
          if (citySnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (citySnapshot.hasError) {
            return Center(child: Text('Error loading city: ${citySnapshot.error}'));
          }

          if (!citySnapshot.hasData || !citySnapshot.data!.exists) {
            return const Center(child: Text('City not found.'));
          }

          final cityData = citySnapshot.data!.data() as Map<String, dynamic>;
          final cityImage = cityData['imageUrl'] ?? '';
          final cityDescription = cityData['description'] ?? '';

          return StreamBuilder<QuerySnapshot>(
            stream: categoriesRef.snapshots(),
            builder: (context, categorySnapshot) {
              if (categorySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (categorySnapshot.hasError) {
                return Center(child: Text('Error loading categories: ${categorySnapshot.error}'));
              }

              final categories = categorySnapshot.data?.docs ?? [];

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  if (cityImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        cityImage,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 220,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[300],
                            child: Icon(Icons.location_city, size: 80, color: Colors.white70),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 12),
                  Text(
                    cityDescription,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 24),
                  Divider(),
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (categories.isEmpty)
                    Center(child: Text('No categories found.'))
                  else
                    ...categories.map((categoryDoc) {
                      final category = categoryDoc.data() as Map<String, dynamic>;
                      final categoryName = category['name'] ?? 'Unknown Category';
                      final categoryId = categoryDoc.id;

                      return StreamBuilder<QuerySnapshot>(
                        stream: cityRef
                            .collection('attractions')
                            .where('categoryId', isEqualTo: categoryId)
                            .snapshots(),
                        builder: (context, attrSnapshot) {
                          final count = attrSnapshot.data?.docs.length ?? 0;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                categoryName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('$count attraction${count != 1 ? 's' : ''}'),
                              trailing: Icon(Icons.arrow_forward_ios, size: 18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UserCategoryAttractionsPage(
                                      cityId: cityId,
                                      categoryId: categoryId,
                                      categoryName: categoryName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
