import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/review_service.dart';
import '../../models/review_model.dart';
import 'add_review_page.dart';

class AttractionDetailsPage extends StatefulWidget {
  final String cityId;
  final String attractionId;

  const AttractionDetailsPage({
    super.key,
    required this.cityId,
    required this.attractionId,
  });

  @override
  State<AttractionDetailsPage> createState() => _AttractionDetailsPageState();
}

class _AttractionDetailsPageState extends State<AttractionDetailsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final ReviewService _reviewService = ReviewService();

  bool _isFavorite = false;
  bool _loadingFavorite = true;
  String? _cityName;

  @override
  void initState() {
    super.initState();
    _loadCityName();
    _checkFavorite();
  }

  Future<void> _loadCityName() async {
    final cityDoc = await FirebaseFirestore.instance
        .collection('cities')
        .doc(widget.cityId)
        .get();

    setState(() {
      _cityName = cityDoc.data()?['name'] ?? 'Unknown City';
    });
  }

  Future<void> _checkFavorite() async {
    if (user == null) return;

    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.attractionId)
        .get();

    setState(() {
      _isFavorite = favDoc.exists;
      _loadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite(Map<String, dynamic> attractionData) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites')),
      );
      return;
    }

    setState(() => _loadingFavorite = true);

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.attractionId);

    if (_isFavorite) {
      await favRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      await favRef.set({
        'cityId': widget.cityId,
        'cityName': _cityName ?? 'Unknown City',
        'attractionName': attractionData['name'] ?? 'Unnamed Attraction',
        'imageUrl': attractionData['imageUrl'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    }

    setState(() {
      _isFavorite = !_isFavorite;
      _loadingFavorite = false;
    });
  }

  Future<void> _toggleLike(String reviewId, Map<String, dynamic>? likes) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like reviews')),
      );
      return;
    }

    await _reviewService.toggleLike(
      cityId: widget.cityId,
      attractionId: widget.attractionId,
      reviewId: reviewId,
      userId: user!.uid,
    );
  }

  void _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openInMap(double lat, double lng) async {
    final Uri uri =
    Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final attractionRef = FirebaseFirestore.instance
        .collection('cities')
        .doc(widget.cityId)
        .collection('attractions')
        .doc(widget.attractionId);

    return Scaffold(
      appBar: AppBar(title: const Text('Attraction Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: attractionRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Attraction not found.'));
          }

          final attraction = snapshot.data!.data() as Map<String, dynamic>;
          final name = attraction['name'] ?? 'Unknown Attraction';
          final description = attraction['description'] ?? '';
          final imageUrl = attraction['imageUrl'] ?? '';
          final phone = attraction['phone'] ?? '';
          final address = attraction['address'] ?? '';
          final latitude = (attraction['latitude'] ?? 0).toString();
          final longitude = (attraction['longitude'] ?? 0).toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE + FAVORITE BUTTON
                if (imageUrl.isNotEmpty)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 220,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image,
                                size: 80, color: Colors.white70),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _loadingFavorite
                            ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : GestureDetector(
                          onTap: () => _toggleFavorite(attraction),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? Colors.red
                                : Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // NAME
                Text(name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // DESCRIPTION
                Text(description,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 20),

                // ADDRESS
                if (address.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(address)),
                    ],
                  ),
                const SizedBox(height: 12),

                // PHONE
                if (phone.isNotEmpty)
                  InkWell(
                    onTap: () => _launchPhone(phone),
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // COORDINATES + MAP
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Lat: $latitude, Lng: $longitude'),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    final lat = double.tryParse(latitude);
                    final lng = double.tryParse(longitude);
                    if (lat != null && lng != null) _openInMap(lat, lng);
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Open in Google Maps'),
                ),
                const SizedBox(height: 20),

                // REVIEWS SECTION
                StreamBuilder<List<ReviewModel>>(
                  stream: _reviewService.getApprovedReviews(
                    widget.cityId,
                    widget.attractionId,
                  ),
                  builder: (context, reviewSnapshot) {
                    if (reviewSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (reviewSnapshot.hasError) {
                      return Text(
                        'Error loading reviews: ${reviewSnapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    if (!reviewSnapshot.hasData ||
                        reviewSnapshot.data!.isEmpty) {
                      return const Text('No approved reviews yet.');
                    }

                    final reviews = reviewSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reviews.map((r) {
                        final likes = r.likes;
                        final likeCount = likes.length;
                        final hasLiked =
                            user != null && likes.containsKey(user!.uid);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(r.userName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.comment),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _toggleLike(r.id, likes),
                                      icon: Icon(
                                        hasLiked
                                            ? Icons.thumb_up : Icons.thumb_up_outlined,
                                        color: hasLiked
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text('$likeCount likes'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                    (i) => Icon(
                                  i < r.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ADD REVIEW
                AddReviewWidget(
                  cityId: widget.cityId,
                  attractionId: widget.attractionId,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
