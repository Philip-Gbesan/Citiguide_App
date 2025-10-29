import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

// Provides an instance of CategoryService
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

//Provides a stream of all categories
final categoryListProvider = StreamProvider<List<CategoryModel>>((ref) {
  final service = ref.watch(categoryServiceProvider);
  return service.getCategoriesStream(); // Ensure this matches your CategoryService method
});
