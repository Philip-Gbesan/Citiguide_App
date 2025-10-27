import 'package:flutter/material.dart';

import '../../models/city_model.dart';
import '../../models/event_model.dart';
import '../../services/city_service.dart';
import '../../services/event_service.dart';

class EventManagementPage extends StatefulWidget {
  const EventManagementPage({super.key});

  @override
  State<EventManagementPage> createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage> {
  final EventService _eventService = EventService();
  String _filterStatus = 'all'; // 'all', 'active', 'inactive'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filterStatus = value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All Events')),
              PopupMenuItem(value: 'active', child: Text('Active Only')),
              PopupMenuItem(value: 'inactive', child: Text('Inactive Only')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        icon: Icon(Icons.add),
        label: Text('Add Event'),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: _eventService.getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No events yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEventDialog(),
                    icon: Icon(Icons.add),
                    label: Text('Create First Event'),
                  ),
                ],
              ),
            );
          }

          var events = snapshot.data!;

          // Filter events
          if (_filterStatus == 'active') {
            events = events.where((e) => e.isActive).toList();
          } else if (_filterStatus == 'inactive') {
            events = events.where((e) => !e.isActive).toList();
          }

          if (events.isEmpty) {
            return Center(child: Text('No ${_filterStatus} events found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    final isUpcoming = event.startDate.isAfter(DateTime.now());
    final isOngoing =
        DateTime.now().isAfter(event.startDate) &&
        DateTime.now().isBefore(event.endDate);
    final isPast = event.endDate.isBefore(DateTime.now());

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                event.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: Icon(Icons.event, size: 60),
                  );
                },
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title & Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(
                      event.isActive,
                      isUpcoming,
                      isOngoing,
                      isPast,
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Date Range
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Description
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEditEventDialog(event),
                      icon: Icon(Icons.edit, size: 18),
                      label: Text('Edit'),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _toggleEventStatus(event),
                      icon: Icon(
                        event.isActive
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18,
                      ),
                      label: Text(event.isActive ? 'Deactivate' : 'Activate'),
                      style: TextButton.styleFrom(
                        foregroundColor: event.isActive
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _deleteEvent(event),
                      icon: Icon(Icons.delete, size: 18),
                      label: Text('Delete'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    bool isActive,
    bool isUpcoming,
    bool isOngoing,
    bool isPast,
  ) {
    String label;
    Color color;

    if (!isActive) {
      label = 'INACTIVE';
      color = Colors.grey;
    } else if (isOngoing) {
      label = 'ONGOING';
      color = Colors.green;
    } else if (isUpcoming) {
      label = 'UPCOMING';
      color = Colors.blue;
    } else {
      label = 'PAST';
      color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddEventDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditEventPage()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _showEditEventDialog(EventModel event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditEventPage(event: event)),
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _toggleEventStatus(EventModel event) async {
    await _eventService.toggleEventStatus(event.id, !event.isActive);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event.isActive ? 'Event deactivated' : 'Event activated'),
      ),
    );
  }

  void _deleteEvent(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _eventService.deleteEvent(event.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Event deleted')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Add/Edit Event Page
class AddEditEventPage extends StatefulWidget {
  final EventModel? event;

  const AddEditEventPage({super.key, this.event});

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();
  final CityService _cityService = CityService();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  late TextEditingController _ticketInfoController;

  String? _selectedCityId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event?.name ?? '');
    _descController = TextEditingController(
      text: widget.event?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.event?.location ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.event?.imageUrl ?? '',
    );
    _ticketInfoController = TextEditingController(
      text: widget.event?.ticketInfo ?? '',
    );

    _selectedCityId = widget.event?.cityId;
    _startDate = widget.event?.startDate;
    _endDate = widget.event?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Edit Event'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // City Selector
            StreamBuilder<List<CityModel>>(
              stream: _cityService.getCitiesStream(),
              builder: (context, snapshot) {
                final cities = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedCityId,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city.id,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCityId = value),
                  validator: (value) => value == null ? 'Select a city' : null,
                );
              },
            ),
            SizedBox(height: 16),

            // Event Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter event name' : null,
            ),
            SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter description' : null,
            ),
            SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter location' : null,
            ),
            SizedBox(height: 16),

            // Start Date
            ListTile(
              title: Text('Start Date'),
              subtitle: Text(
                _startDate == null ? 'Not selected' : _formatDate(_startDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) setState(() => _startDate = date);
              },
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 16),

            // End Date
            ListTile(
              title: Text('End Date'),
              subtitle: Text(
                _endDate == null ? 'Not selected' : _formatDate(_endDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? _startDate ?? DateTime.now(),
                  firstDate: _startDate ?? DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) setState(() => _endDate = date);
              },
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 16),

            // Image URL
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Ticket Info
            TextFormField(
              controller: _ticketInfoController,
              decoration: InputDecoration(
                labelText: 'Ticket Info (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.event == null ? 'Create Event' : 'Update Event',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.event == null) {
        // Add new event
        await _eventService.addEvent(
          cityId: _selectedCityId!,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          location: _locationController.text.trim(),
          ticketInfo: _ticketInfoController.text.trim().isEmpty
              ? null
              : _ticketInfoController.text.trim(),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Event created successfully')));
      } else {
        // Update existing event
        await _eventService.updateEvent(
          eventId: widget.event!.id,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          location: _locationController.text.trim(),
          ticketInfo: _ticketInfoController.text.trim().isEmpty
              ? null
              : _ticketInfoController.text.trim(),
          isActive: widget.event!.isActive,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Event updated successfully')));
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
