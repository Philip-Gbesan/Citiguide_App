import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/analytics_service.dart';
import '../services/event_service.dart';
import '../services/notification_service.dart';
import '../services/user_management_service.dart';

final eventServiceProvider = Provider((ref) => EventService());
final notificationServiceProvider = Provider((ref) => NotificationService());
final userManagementServiceProvider = Provider(
  (ref) => UserManagementService(),
);
final analyticsServiceProvider = Provider((ref) => AnalyticsService());
