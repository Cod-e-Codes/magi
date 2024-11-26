import 'package:flutter/material.dart';
import 'package:magi/screens/manage_events_page.dart';
import '../screens/manage_families_page.dart';
import '../screens/add_family_page.dart';

// Quick Actions Card Widget
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Define quick actions
    final List<QuickAction> actions = [
      QuickAction(
        icon: Icons.group_add,
        color: Colors.blue,
        label: 'Add Family',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFamilyPage(),
            ),
          );
        },
      ),
      QuickAction(
        icon: Icons.search,
        color: Colors.green,
        label: 'Search',
        onTap: () {
          // Navigate to ManageFamiliesPage and auto-focus the search bar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ManageFamiliesPage(autoFocusSearch: true),
            ),
          );
        },
      ),
      QuickAction(
        icon: Icons.event,
        color: Colors.orange,
        label: 'Events',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageEventsPage(),
            ),
          );
        },
      ),
      QuickAction(
        icon: Icons.insert_chart,
        color: Colors.purple,
        label: 'Reports',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reports functionality coming soon!'),
            ),
          );
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 600;

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Remove hardcoded color to use theme default
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Actions Grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: actions.map((action) {
                    return SizedBox(
                      width: isDesktop
                          ? (constraints.maxWidth - 80) / 2
                          : (constraints.maxWidth - 64) / 2,
                      child: QuickActionButton(action: action),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// QuickAction Model
class QuickAction {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  QuickAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}

// Quick Action Button Widget
class QuickActionButton extends StatelessWidget {
  final QuickAction action;

  const QuickActionButton({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: action.color.withOpacity(0.1),
        foregroundColor: action.color,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            action.icon,
            size: 30,
            color: action.color,
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: TextStyle(
              color: action.color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
