import 'package:flutter/material.dart';

import '../../models/city_model.dart';
import '../../models/notification_model.dart';
import '../../services/city_service.dart';
import '../../services/notification_service.dart';

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() =>
      _NotificationManagementPageState();
}

class _NotificationManagementPageState
    extends State<NotificationManagementPage> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNotificationDialog(),
        icon: Icon(Icons.add),
        label: Text('Create Notification'),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateNotificationDialog(),
                    icon: Icon(Icons.add),
                    label: Text('Create First Notification'),
                  ),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(notification);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final isScheduled =
        notification.scheduledFor != null &&
        notification.scheduledFor!.isAfter(DateTime.now());
    final isSent = notification.isSent;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusChip(isSent, isScheduled),
              ],
            ),
            SizedBox(height: 12),

            // Message
            Text(
              notification.message,
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(height: 12),

            // Target Audience
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  _getAudienceText(notification),
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Recipient Count
            if (notification.recipientCount != null)
              Row(
                children: [
                  Icon(Icons.send, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    '${notification.recipientCount} recipients',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            SizedBox(height: 8),

            // Schedule Info
            if (notification.scheduledFor != null)
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    isScheduled
                        ? 'Scheduled for ${_formatDateTime(notification.scheduledFor!)}'
                        : 'Was scheduled for ${_formatDateTime(notification.scheduledFor!)}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),

            // Created Date
            SizedBox(height: 8),
            Text(
              'Created: ${_formatDateTime(notification.createdAt.toDate())}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isSent)
                  TextButton.icon(
                    onPressed: () => _deleteNotification(notification),
                    icon: Icon(Icons.delete, size: 18),
                    label: Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isSent, bool isScheduled) {
    String label;
    Color color;
    IconData icon;

    if (isSent) {
      label = 'SENT';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (isScheduled) {
      label = 'SCHEDULED';
      color = Colors.orange;
      icon = Icons.schedule;
    } else {
      label = 'DRAFT';
      color = Colors.grey;
      icon = Icons.drafts;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getAudienceText(NotificationModel notification) {
    switch (notification.targetAudience) {
      case 'all':
        return 'All Users';
      case 'city':
        return 'Users in specific city';
      default:
        return 'Custom audience';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showCreateNotificationDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateNotificationPage()),
    );
  }

  void _deleteNotification(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notification'),
        content: Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _notificationService.deleteNotification(notification.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Notification deleted')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Create Notification Page
class CreateNotificationPage extends StatefulWidget {
  const CreateNotificationPage({super.key});

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final NotificationService _notificationService = NotificationService();
  final CityService _cityService = CityService();

  late TextEditingController _titleController;
  late TextEditingController _messageController;
  late TextEditingController _imageUrlController;

  String _targetAudience = 'all';
  String? _selectedCityId;
  DateTime? _scheduledFor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Notification'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Step 1: Target Audience
            Text(
              'Step 1: Target Audience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('All Users'),
                    subtitle: Text('Send to everyone'),
                    value: 'all',
                    groupValue: _targetAudience,
                    onChanged: (value) {
                      setState(() {
                        _targetAudience = value!;
                        _selectedCityId = null;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Users in Specific City'),
                    subtitle: Text(
                      'Target users who favorited attractions in a city',
                    ),
                    value: 'city',
                    groupValue: _targetAudience,
                    onChanged: (value) {
                      setState(() => _targetAudience = value!);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // City Selector (if city target selected)
            if (_targetAudience == 'city')
              StreamBuilder<List<CityModel>>(
                stream: _cityService.getCitiesStream(),
                builder: (context, snapshot) {
                  final cities = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    value: _selectedCityId,
                    decoration: InputDecoration(
                      labelText: 'Select City',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city.id,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCityId = value),
                    validator: (value) {
                      if (_targetAudience == 'city' && value == null) {
                        return 'Select a city';
                      }
                      return null;
                    },
                  );
                },
              ),
            SizedBox(height: 24),

            // Step 2: Content
            Text(
              'Step 2: Notification Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., New Event in Lagos!',
                border: OutlineInputBorder(),
                counterText: '${_titleController.text.length}/50',
              ),
              maxLength: 50,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter title' : null,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Your notification message...',
                border: OutlineInputBorder(),
                counterText: '${_messageController.text.length}/150',
              ),
              maxLines: 4,
              maxLength: 150,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter message' : null,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Step 3: Schedule
            Text(
              'Step 3: Delivery Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  RadioListTile<bool>(
                    title: Text('Send Immediately'),
                    subtitle: Text('Deliver right away'),
                    value: true,
                    groupValue: _scheduledFor == null,
                    onChanged: (value) {
                      setState(() => _scheduledFor = null);
                    },
                  ),
                  RadioListTile<bool>(
                    title: Text('Schedule for Later'),
                    subtitle: _scheduledFor == null
                        ? Text('Choose date and time')
                        : Text('Scheduled: ${_formatDateTime(_scheduledFor!)}'),
                    value: false,
                    groupValue: _scheduledFor == null,
                    onChanged: (value) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(Duration(hours: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _scheduledFor = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Preview Card
            Text(
              'Preview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildPreview(),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitNotification,
              icon: Icon(
                _scheduledFor == null ? Icons.send : Icons.schedule_send,
              ),
              label: Text(
                _scheduledFor == null
                    ? 'Send Notification'
                    : 'Schedule Notification',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Card(
      color: Colors.indigo.withOpacity(0.1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          _titleController.text.isEmpty
              ? 'Notification Title'
              : _titleController.text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _messageController.text.isEmpty
              ? 'Your message will appear here'
              : _messageController.text,
        ),
        trailing: Text(
          'now',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _submitNotification() async {
    if (!_formKey.currentState!.validate()) return;

    // Confirm sending
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text(
          _scheduledFor == null
              ? 'Send this notification immediately?'
              : 'Schedule this notification for ${_formatDateTime(_scheduledFor!)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await _notificationService.createNotification(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        targetAudience: _targetAudience,
        cityId: _selectedCityId,
        scheduledFor: _scheduledFor,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _scheduledFor == null
                ? 'Notification sent successfully!'
                : 'Notification scheduled successfully!',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
