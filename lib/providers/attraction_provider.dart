import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attraction_model.dart';
import '../services/attraction_service.dart';

// Provide an instance of AttractionService
final attractionServiceProvider = Provider<AttractionService>((ref) {
  return AttractionService();
});

// StreamProvider for attractions by city (already existing)
final cityAttractionsProvider = StreamProvider.family<List<AttractionModel>, String>((ref, cityId) {
  final service = ref.watch(attractionServiceProvider);
  return service.getAllAttractions(cityId);
});

// StreamProvider for attractions by category across all cities
final attractionsByCategoryProvider = StreamProvider.family<List<AttractionModel>, String>((ref, categoryId) {
  final service = ref.watch(attractionServiceProvider);
  return service.getAttractionsByCategory(categoryId);
});
