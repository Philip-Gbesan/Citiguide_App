import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFavoritesPage extends StatefulWidget {
  const UserFavoritesPage({super.key});

  @override
  State<UserFavoritesPage> createState() => _UserFavoritesPageState();
}

class _UserFavoritesPageState extends State<UserFavoritesPage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, bool> _loadingFavorites = {};

  Future<void> _toggleFavorite(Map<String, dynamic> attractionData) async {
    if (user == null) return;

    final attractionId = attractionData['id'];
    setState(() => _loadingFavorites[attractionId] = true);

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(attractionId);

    final favDoc = await favRef.get();

    if (favDoc.exists) {
      await favRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      await favRef.set({
        'attractionName': attractionData['name'],
        'imageUrl': attractionData['imageUrl'],
        'cityName': attractionData['cityName'],
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    }

    setState(() => _loadingFavorites[attractionId] = false);
  }


  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view favorites')),
      );
    }

    final favoritesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('My Favorites')),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }

          final favorites = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index].data() as Map<String, dynamic>;
              final attractionId = favorites[index].id;
              final name = fav['attractionName'] ?? 'Unnamed';
              final imageUrl = fav['imageUrl'] ?? '';
              final cityName = fav['cityName'] ?? '';

              final isLoading = _loadingFavorites[attractionId] ?? false;

              return Stack(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, size: 60),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.place_outlined, size: 60),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.grey[100],
                          child: Column(
                            children: [
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (cityName.isNotEmpty)
                                Text(
                                  cityName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Favorite icon overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: isLoading
                        ? SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                    )
                        : GestureDetector(
                            onTap: () => _toggleFavorite({
                            'id': attractionId,
                            'name': name,
                            'imageUrl': imageUrl,
                            'cityName': cityName,
                            }),

                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
