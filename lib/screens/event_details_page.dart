import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import '../screens/edit_event_page.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool showAppBar;

  const EventDetailsPage({
    super.key,
    required this.event,
    this.showAppBar = true, // Defaults to showing app bar
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event: ${event['name'] ?? 'No Name'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(context, 'ID', event['id'] ?? 'N/A'),
              _buildDetailRow(context, 'Start Date', formatDate(event['start_date_time'])),
              _buildDetailRow(context, 'End Date', formatDate(event['end_date_time'])),
              _buildDetailRow(context, 'Is Christmas', event['isChristmas'] == '1' ? 'Yes' : 'No'),
              _buildDetailRow(context, 'Registration Open', event['registration_open'] == '1' ? 'Yes' : 'No'),
              _buildDetailRow(context, 'Enabled', event['enabled'] == '1' ? 'Yes' : 'No'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the EditEventPage with the event data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(event: event),
                    ),
                  );
                },
                child: Text(
                  'Edit Event',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Event: ${event['name'] ?? ''}',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        body: content,
      );
    } else {
      return content; // No Scaffold wrapping if showAppBar is false
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is String) {
      // Convert to int if it's a string
      timestamp = int.tryParse(timestamp);
    }
    if (timestamp is! int) return 'N/A'; // Ensure it's an int
    try {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('yyyy-MM-dd – HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
