# 🔧 Admin System Integration Guide

## 📁 File Structure

Add these new files to your project:

```
lib/
├── models/
│   ├── event_model.dart          ✅ CREATED
│   ├── notification_model.dart   ✅ CREATED
│   └── analytics_model.dart      ✅ CREATED
│
├── services/
│   ├── event_service.dart             ✅ CREATED
│   ├── notification_service.dart      ✅ CREATED
│   ├── user_management_service.dart   ✅ CREATED
│   └── analytics_service.dart         ✅ CREATED
│
└── pages/
    └── admin/
        ├── enhanced_admin_dashboard.dart  ✅ CREATED
        ├── user_management_page.dart      ✅ CREATED
        ├── event_management_page.dart     ⏳ CREATE NEXT
        ├── notification_page.dart         ⏳ CREATE NEXT
        └── analytics_page.dart            ⏳ CREATE NEXT
```

## 🔗 Step 1: Update main.dart

Replace your existing `main.dart` with this updated version:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'splash_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/forgot_password_page.dart';
import 'pages/admin/enhanced_admin_dashboard.dart';  // 👈 NEW
import 'pages/admin/add_city_page.dart';
import 'pages/admin/add_attraction_page.dart';
import 'pages/admin/city_list_page.dart';
import 'pages/admin/manage_attraction_page.dart';
import 'pages/admin/manage_review_page.dart';
import 'pages/admin/user_management_page.dart';  // 👈 NEW
import 'pages/users/user_dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginPage();

    final authService = AuthService();
    final userModel = await authService.getUserData(user.uid);
    if (userModel == null) return const LoginPage();

    return userModel.role == 'admin'
        ? const EnhancedAdminDashboard()  // 👈 UPDATED
        : const UserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Guide App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return snapshot.data ?? const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/adminDashboard': (context) => const EnhancedAdminDashboard(),  // 👈 UPDATED
        '/userDashboard': (context) => const UserDashboard(),
        '/addCity': (context) => const AddCityPage(),
        '/cityList': (context) => const CityListPage(),
        '/addAttraction': (context) => const AddAttractionPage(),
        '/manageAttractions': (context) => const ManageAttractionsPage(),
        '/manageReviews': (context) => const ManageReviewsPage(),
        '/userManagement': (context) => const UserManagementPage(),  // 👈 NEW
      },
    );
  }
}
```

## 🎨 Step 2: Update User Model

Add these fields to your existing `user_model.dart`:

```dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String role;
  final bool isBanned;            // 👈 ADD
  final String? banReason;        // 👈 ADD
  final DateTime? bannedAt;       // 👈 ADD

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.role = "user",
    this.isBanned = false,        // 👈 ADD
    this.banReason,                // 👈 ADD
    this.bannedAt,                 // 👈 ADD
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: data['role'] ?? 'user',
      isBanned: data['isBanned'] ?? false,                    // 👈 ADD
      banReason: data['banReason'],                          // 👈 ADD
      bannedAt: data['bannedAt'] != null                     // 👈 ADD
          ? (data['bannedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'isBanned': isBanned,                               // 👈 ADD
      'banReason': banReason,                             // 👈 ADD
      'bannedAt': bannedAt != null                        // 👈 ADD
          ? Timestamp.fromDate(bannedAt!)
          : null,
    };
  }
}
```

## 🔥 Step 3: Firestore Database Structure

Your Firestore should have these collections:

```
cities/
  └── {cityId}/
      └── attractions/
          └── {attractionId}/
              └── reviews/

users/
  └── {userId}/
      ├── favorites/
      ├── notifications/
      └── warnings/

events/
  └── {eventId}

notifications/
  └── {notificationId}

admin_actions/
  └── {actionId}
```

## 📊 Step 4: Firestore Indexes (IMPORTANT!)

Add these compound indexes in Firebase Console:

1. **Collection Group: reviews**
    - Fields: `approved (Ascending)`, `createdAt (Descending)`

2. **Collection Group: favorites**
    - Fields: `cityId (Ascending)`, `createdAt (Descending)`

3. **Collection: events**
    - Fields: `cityId (Ascending)`, `isActive (Ascending)`, `startDate (Ascending)`

## 🎯 Step 5: Testing the Admin System

### Test Admin Access:

1. **Create an admin user:**
```dart
// In your register page or Firestore console
{
  "uid": "admin123",
  "name": "Admin User",
  "email": "admin@cityguide.com",
  "role": "admin",
  "isBanned": false
}
```

2. **Login as admin** - You should see the new Enhanced Admin Dashboard

3. **Test features:**
    - ✅ View statistics on dashboard
    - ✅ Navigate using the drawer menu
    - ✅ Add/Edit cities
    - ✅ Add/Edit attractions
    - ✅ Moderate reviews
    - ✅ Manage users (new!)

## 🚀 Step 6: Additional Admin Pages to Create

### Event Management Page (event_management_page.dart):

```dart
import 'package:flutter/material.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class EventManagementPage extends StatelessWidget {
  const EventManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to add event page
            },
          ),
        ],
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: eventService.getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data ?? [];
          
          if (events.isEmpty) {
            return Center(child: Text('No events yet'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text(event.location),
                trailing: Switch(
                  value: event.isActive,
                  onChanged: (value) {
                    eventService.toggleEventStatus(event.id, value);
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
```

### Notification Management Page (notification_page.dart):

```dart
import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() => _NotificationManagementPageState();
}

class _NotificationManagementPageState extends State<NotificationManagementPage> {
  final notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateDialog(),
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data ?? [];
          
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return ListTile(
                title: Text(notif.title),
                subtitle: Text(notif.message),
                trailing: Icon(
                  notif.isSent ? Icons.check_circle : Icons.schedule,
                  color: notif.isSent ? Colors.green : Colors.orange,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    // Implementation for creating notification
  }
}
```

## ✅ Verification Checklist

- [ ] All model files created
- [ ] All service files created
- [ ] Enhanced admin dashboard working
- [ ] User management page accessible
- [ ] Old admin pages still work
- [ ] Routing updated in main.dart
- [ ] Firestore indexes created
- [ ] Admin user created for testing
- [ ] All drawer menu items navigate correctly

## 🎨 UI/UX Features

The new admin system includes:

✨ **Modern Dashboard**
- Real-time statistics
- Quick action cards
- Pending items alerts
- Welcome message

✨ **Navigation Drawer**
- Organized sections
- Current page highlighting
- User info header

✨ **User Management**
- Search functionality
- User stats display
- Multiple actions (warn, ban, delete)
- Role management

✨ **Responsive Design**
- Works on tablets
- Adapts to screen sizes
- Material 3 design

## 🐛 Common Issues & Solutions

### Issue: "Index not found" error
**Solution:** Create the Firestore indexes in Firebase Console

### Issue: Admin dashboard doesn't show statistics
**Solution:** Ensure analytics_service.dart is properly imported

### Issue: Can't access user management
**Solution:** Check that the route is added in main.dart

## 📞 Next Steps

1. ✅ Create remaining admin pages (events, notifications, analytics)
2. ✅ Add loading states to all pages
3. ✅ Implement search and filters
4. ✅ Add data export features
5. ✅ Create admin activity logs
6. ✅ Add email notifications for admin actions

## 🎯 Future Enhancements

- **Advanced Analytics:** Charts with fl_chart package
- **Bulk Operations:** Select multiple users/items
- **Export Reports:** PDF/CSV generation
- **Activity Timeline:** Track all admin actions
- **Push Notifications:** FCM integration
- **Scheduled Tasks:** Cron jobs for notifications

---

**Made with ❤️ following the Admin Flow Documentation**

*Need help? Review ADMIN_FLOW.md and ADMIN_FLOWCHARTS.md*