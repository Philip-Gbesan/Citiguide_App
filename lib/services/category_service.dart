import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new category
  Future<void> addCategory(CategoryModel category) async {
    final docRef = _firestore.collection('categories').doc();
    await docRef.set({
      'id': docRef.id,
      'name': category.name,
      'description': category.description,
      'imageUrl': category.imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //Get all categories as a Future
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(
      doc.data(),
      doc.id, // pass as second positional argument
    ))
        .toList();
  }

  // Stream all categories
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return CategoryModel(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList());
  }



  // Delete a category by its ID
  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }

  // Update category
  Future<void> updateCategory(CategoryModel category) async {
    final docRef = _firestore.collection('categories').doc(category.id);
    await docRef.update({
      'name': category.name,
      'description': category.description,
      'imageUrl': category.imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
