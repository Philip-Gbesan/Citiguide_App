import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attraction_details_page.dart';

class UserCategoryAttractionsPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String cityId;

  const UserCategoryAttractionsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    final attractionsRef = FirebaseFirestore.instance
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .where('categoryId', isEqualTo: categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: attractionsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final attractions = snapshot.data?.docs ?? [];

          if (attractions.isEmpty) {
            return Center(
              child: Text('No attractions found in this category.'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              final doc = attractions[index];
              final attraction = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: attraction['imageUrl'] != null &&
                      attraction['imageUrl'].toString().isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attraction['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: Icon(Icons.place_outlined, size: 30),
                      ),
                    ),
                  )
                      : Icon(Icons.place_outlined, size: 40),
                  title: Text(
                    attraction['name'] ?? 'Unknown Attraction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    attraction['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttractionDetailsPage(
                          cityId: cityId,
                          attractionId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
