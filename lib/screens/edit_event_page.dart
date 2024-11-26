import 'package:flutter/material.dart';
import 'manage_events_page.dart';
import 'package:intl/intl.dart'; // For formatting dates

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> event; // Accept the event data

  const EditEventPage({super.key, required this.event});

  @override
  EditEventPageState createState() => EditEventPageState();
}

class EditEventPageState extends State<EditEventPage> {
  int _currentStep = 0;
  late TextEditingController _eventNameController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  bool _isChristmasEvent = false;
  bool _isRegistrationOpen = false;
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing event data
    _eventNameController = TextEditingController(text: widget.event['name']);
    _startDateController = TextEditingController(
      text: _formatDate(widget.event['start_date_time']),
    );
    _endDateController = TextEditingController(
      text: _formatDate(widget.event['end_date_time']),
    );
    _isChristmasEvent = widget.event['isChristmas'] == '1';
    _isRegistrationOpen = widget.event['registration_open'] == '1';
    _isEnabled = widget.event['enabled'] == '1';
  }

  /// Function to format date from Unix timestamp (in seconds).
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return ''; // Return an empty string if timestamp is null
    try {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        timestamp is int ? timestamp * 1000 : int.parse(timestamp) * 1000,
      );
      return DateFormat('yyyy-MM-dd').format(date); // Format as 'yyyy-MM-dd'
    } catch (e) {
      return ''; // Return empty if parsing fails
    }
  }

  /// Function to handle date selection.
  Future<DateTime?> _selectDate(BuildContext context, String controller) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selected != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selected);
      if (controller == 'start') {
        _startDateController.text = formattedDate;
      } else {
        _endDateController.text = formattedDate;
      }
    }
    return selected;
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Event Information'),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Event Dates'),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  await _selectDate(context, 'start');
                },
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  await _selectDate(context, 'end');
                },
                readOnly: true,
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Event Settings'),
        content: Column(
          children: [
            SwitchListTile(
              title: const Text('Is this a Christmas Event?'),
              value: _isChristmasEvent,
              onChanged: (bool value) {
                setState(() {
                  _isChristmasEvent = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Registration Open'),
              value: _isRegistrationOpen,
              onChanged: (bool value) {
                setState(() {
                  _isRegistrationOpen = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enabled'),
              value: _isEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isEnabled = value;
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  void _onStepContinue() {
    if (_currentStep < getSteps().length - 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _submitEventDetails();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _submitEventDetails() {
    debugPrint('Updated Event Details:');
    debugPrint('Event Name: ${_eventNameController.text}');
    debugPrint('Start Date: ${_startDateController.text}');
    debugPrint('End Date: ${_endDateController.text}');
    debugPrint('Is Christmas Event: $_isChristmasEvent');
    debugPrint('Registration Open: $_isRegistrationOpen');
    debugPrint('Enabled: $_isEnabled');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event details updated!'),
      ),
    );

    // Navigate back to ManageEventsPage after submission
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ManageEventsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: getSteps(),
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _currentStep == getSteps().length - 1;

          return Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? 'Save' : 'Next'),
              ),
              const SizedBox(width: 10),
              if (_currentStep != 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
      ),
    );
  }
}
