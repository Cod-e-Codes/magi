import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../screens/event_details_page.dart';
import 'add_event_page.dart'; // Assuming you have an AddEventPage for adding new events
import 'package:intl/intl.dart'; // For formatting date and time

class ManageEventsPage extends StatefulWidget {
  final bool autoFocusSearch;

  const ManageEventsPage({super.key, this.autoFocusSearch = false});

  @override
  ManageEventsPageState createState() => ManageEventsPageState();
}

class ManageEventsPageState extends State<ManageEventsPage> {
  List<dynamic> events = [];
  List<dynamic> filteredEvents = [];
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? selectedEvent;

  @override
  void initState() {
    super.initState();
    fetchAllEvents();
    searchController.addListener(() {
      filterEvents();
    });
  }

  Future<void> fetchAllEvents() async {
    try {
      debugPrint("Fetching all events...");
      List<dynamic> data = await DatabaseHelper.fetchAllEvents();
      debugPrint("Fetched events: $data");
      setState(() {
        events = data;
        filteredEvents = data;
      });
    } catch (e) {
      debugPrint("Error fetching events: $e");
    }
  }

  void filterEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = events.where((event) {
        return (event['name'] ?? '').toLowerCase().contains(query) ||
            (event['start_date_time'] != null && event['start_date_time'] is int
                ? formatDate(event['start_date_time'])
                : 'N/A').toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null || timestamp is! int) return 'N/A';
    try {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('yyyy-MM-dd – HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: isLargeScreen
          ? Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                buildSearchBar(),
                Expanded(child: buildEventList(isLargeScreen)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedEvent != null
                ? EventDetailsPage(
              event: selectedEvent!,
              showAppBar: false, // No app bar in split-screen
            )
                : Center(
              child: Text(
                'Select an event to view details',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
          ),
        ],
      )
          : Column(
        children: [
          buildSearchBar(),
          Expanded(child: buildEventList(isLargeScreen)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventPage(), // Add Event Page to be created
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        autofocus: widget.autoFocusSearch,
        decoration: InputDecoration(
          labelText: 'Search Events',
          prefixIcon: const Icon(Icons.search),
          labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
        ),
      ),
    );
  }

  Widget buildEventList(bool isLargeScreen) {
    String searchQuery = searchController.text.toLowerCase();

    return events.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      key: ValueKey(Theme.of(context).brightness), // Force rebuild on theme change
      itemCount: filteredEvents.length,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
      itemBuilder: (context, index) {
        var event = filteredEvents[index];
        String eventName = event['name'] ?? '';

        var startDateRaw = event['start_date_time'];
        var endDateRaw = event['end_date_time'];

        // Convert to int if they are strings
        int? startDateInt = (startDateRaw != null && startDateRaw is String)
            ? int.tryParse(startDateRaw)
            : startDateRaw as int?;

        int? endDateInt = (endDateRaw != null && endDateRaw is String)
            ? int.tryParse(endDateRaw)
            : endDateRaw as int?;

        String startDate = (startDateInt != null)
            ? formatDate(startDateInt)
            : 'N/A';
        String endDate = (endDateInt != null)
            ? formatDate(endDateInt)
            : 'N/A';

        bool isChristmas = (event['isChristmas'] == '1');
        bool registrationOpen = (event['registration_open'] == '1');
        bool enabled = (event['enabled'] == '1');

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: RichText(
              text: highlightSearchText(eventName, searchQuery, context),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: highlightSearchText(
                      'Start Date: $startDate', searchQuery, context),
                ),
                RichText(
                  text: highlightSearchText(
                      'End Date: $endDate', searchQuery, context),
                ),
                Text('Christmas Event: ${isChristmas ? 'Yes' : 'No'}'),
                Text('Registration Open: ${registrationOpen ? 'Yes' : 'No'}'),
                Text('Enabled: ${enabled ? 'Yes' : 'No'}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                if (isLargeScreen) {
                  setState(() {
                    selectedEvent = event;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        event: event,
                        showAppBar: true, // Show app bar on smaller screens
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  TextSpan highlightSearchText(String text, String query, BuildContext context) {
    final TextStyle normalStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle highlightStyle = normalStyle.copyWith(
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.bold,
    );

    if (query.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfHighlight), style: normalStyle));
      }

      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + lowerQuery.length),
        style: highlightStyle,
      ));

      start = indexOfHighlight + lowerQuery.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return TextSpan(children: spans);
  }
}
