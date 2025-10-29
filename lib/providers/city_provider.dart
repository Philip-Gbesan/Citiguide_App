
import 'package:citiguide_app/models/city_model.dart';
import 'package:citiguide_app/services/city_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cityServiceProvider = Provider<CityService>((ref) => CityService());

final cityListProvider = StreamProvider<List<CityModel>>((ref) {
  final service = ref.watch(cityServiceProvider);
  return service.getCitiesStream();
} );