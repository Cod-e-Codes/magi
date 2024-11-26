// recent_activity_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<dynamic> data;

  const RecentActivityWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Filter activities within the last 30 days
    final recentActivity = data.where((item) {
      if (item['dolu'] != null && item['dolu'] is String) {
        DateTime? doluDate = DateTime.tryParse(item['dolu']);
        if (doluDate != null) {
          return now.difference(doluDate).inDays <= 30;
        }
      }
      return false;
    }).toList();

    // Sort activities by date, from newest to oldest
    recentActivity.sort((a, b) {
      DateTime? dateA = DateTime.tryParse(a['dolu'] ?? '');
      DateTime? dateB = DateTime.tryParse(b['dolu'] ?? '');
      if (dateA != null && dateB != null) {
        return dateB.compareTo(dateA); // Newest first
      }
      return 0;
    });

    // Fixed height for the widget
    const double fixedHeight = 300;

    return SizedBox(
      height: fixedHeight,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // Remove hardcoded color
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity (Last 30 Days)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              // Use Expanded to fill remaining space
              Expanded(
                child: recentActivity.isNotEmpty
                    ? ListView.separated(
                  itemCount: recentActivity.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  itemBuilder: (context, index) {
                    var activity = recentActivity[index];
                    DateTime? activityDate;

                    if (activity['dolu'] != null &&
                        activity['dolu'] is String) {
                      activityDate = DateTime.tryParse(activity['dolu']);
                    }

                    String formattedDate = activityDate != null
                        ? DateFormat('MM/dd/yyyy').format(activityDate)
                        : 'Unknown date';

                    return ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        'Activity on $formattedDate',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        'Family ID: ${activity['id'] ?? 'Unknown ID'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    'No recent activity.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
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
