import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/review_provider.dart';
import '../../models/review_model.dart';

class AddReviewWidget extends ConsumerStatefulWidget {
  final String cityId;
  final String attractionId;

  const AddReviewWidget({
    super.key,
    required this.cityId,
    required this.attractionId,
  });

  @override
  ConsumerState<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends ConsumerState<AddReviewWidget> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 3;
  bool _isSubmitting = false;

  Future<String> _getUserName(User user) async {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

    final doc =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data['name'] != null && data['name'].toString().isNotEmpty) {
        return data['name'];
      }
      if (data['username'] != null && data['username'].toString().isNotEmpty) {
        return data['username'];
      }
    }

    return 'Anonymous';
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final service = ref.read(reviewServiceProvider);
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to post a review.')),
        );
        return;
      }

      final userName = await _getUserName(user);

      final review = ReviewModel(
        id: '',
        userId: user.uid,
        userName: userName,
        rating: _rating,
        comment: _commentController.text.trim(),
        approved: false,
        createdAt: DateTime.now(), // ✅ Works perfectly now
        likes: {},
      );


      await service.addReview(widget.cityId, widget.attractionId, review);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted! Waiting for admin approval.'),
        ),
      );

      _commentController.clear();
      setState(() => _rating = 3);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Leave a Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _rating = starIndex.toDouble()),
                  );
                }),
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Write your comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                val == null || val.isEmpty ? 'Please write something' : null,
              ),
              const SizedBox(height: 10),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _submitReview,
                icon: const Icon(Icons.send),
                label: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
