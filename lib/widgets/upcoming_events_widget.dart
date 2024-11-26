import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class UpcomingEventsWidget extends StatelessWidget {
  final List<dynamic> events;

  const UpcomingEventsWidget({super.key, required this.events});

  String _formatDateTime(String epochString) {
    try {
      // Parse the epoch time string to an integer
      int epochTime = int.parse(epochString);
      var date = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000); // Convert seconds to milliseconds
      return DateFormat('yyyy-MM-dd HH:mm').format(date); // Format the date as needed
    } catch (e) {
      return 'Invalid date';
    }
  }

  bool _isFutureEvent(String epochString) {
    try {
      // Parse the epoch time string to an integer
      int epochTime = int.parse(epochString);
      var eventDate = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000); // Convert seconds to milliseconds
      return eventDate.isAfter(DateTime.now()); // Check if the event date is in the future
    } catch (e) {
      return false; // If parsing fails, assume it's not a future event
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fixed height for the widget
    const double fixedHeight = 300;

    // Filter out past events
    final futureEvents = events.where((event) {
      final startDateTime = event['start_date_time'] ?? '0';
      return _isFutureEvent(startDateTime);
    }).toList();

    return SizedBox(
      height: fixedHeight,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              // Use Expanded to fill remaining space
              Expanded(
                child: futureEvents.isNotEmpty
                    ? ListView.builder(
                  itemCount: futureEvents.length,
                  itemBuilder: (context, index) {
                    final event = futureEvents[index];
                    final eventName = event['name'] ?? 'Unnamed Event';
                    final startDateTime = event['start_date_time'] ?? '0';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Starts at: ${_formatDateTime(startDateTime)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    'No upcoming events at this time. Please check again later.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
