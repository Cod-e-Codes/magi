import 'package:flutter/material.dart';
import 'manage_events_page.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  AddEventPageState createState() => AddEventPageState();
}

class AddEventPageState extends State<AddEventPage> {
  int _currentStep = 0;
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _isChristmasEvent = false;
  bool _isRegistrationOpen = false;
  bool _isEnabled = true;

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
                  DateTime? date = await _selectDate(context);
                  if (date != null) {
                    _startDateController.text = "${date.toLocal()}".split(' ')[0];
                  }
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
                  DateTime? date = await _selectDate(context);
                  if (date != null) {
                    _endDateController.text = "${date.toLocal()}".split(' ')[0];
                  }
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

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return selected;
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
    debugPrint('New Event Details:');
    debugPrint('Event Name: ${_eventNameController.text}');
    debugPrint('Start Date: ${_startDateController.text}');
    debugPrint('End Date: ${_endDateController.text}');
    debugPrint('Is Christmas Event: $_isChristmasEvent');
    debugPrint('Registration Open: $_isRegistrationOpen');
    debugPrint('Enabled: $_isEnabled');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event details added!'),
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
        title: const Text('Add Event'),
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
