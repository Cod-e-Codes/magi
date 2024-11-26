// edit_family_page.dart

import 'package:flutter/material.dart';
import 'manage_families_page.dart';

class EditFamilyPage extends StatefulWidget {
  final Map<String, dynamic> family; // Pass the family data

  const EditFamilyPage({super.key, required this.family});

  @override
  EditFamilyPageState createState() => EditFamilyPageState();
}

class EditFamilyPageState extends State<EditFamilyPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for parent information
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  // Controllers for contact information
  late TextEditingController _primaryPhoneController;
  late TextEditingController _secondaryPhoneController;

  // Controllers for household information
  late TextEditingController _adultMembersController;
  late TextEditingController _childMembersController;
  late bool _isActive;

  // Lists to store addresses and children
  late List<Map<String, dynamic>> _addresses;
  late List<Map<String, dynamic>> _children;

  // Placeholder for counselor/staff member name
  final String _editedBy = 'Counselor Name';

  final List<Map<String, String>> _genderOptions = [
    {'value': 'M', 'label': 'Male'},
    {'value': 'F', 'label': 'Female'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing family data
    _firstNameController =
        TextEditingController(text: widget.family['parent_1_fname'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.family['parent_1_lname'] ?? '');
    _emailController =
        TextEditingController(text: widget.family['email'] ?? '');
    _primaryPhoneController =
        TextEditingController(text: widget.family['primary_phone'] ?? '');
    _secondaryPhoneController =
        TextEditingController(text: widget.family['secondary_phone'] ?? '');
    _adultMembersController = TextEditingController(
        text: widget.family['household_adult_members']?.toString() ?? '0');
    _childMembersController = TextEditingController(
        text: widget.family['household_child_members']?.toString() ?? '0');
    _isActive = widget.family['isActive'] == '1';

    // Initialize addresses and children
    _addresses =
        List<Map<String, dynamic>>.from(widget.family['addresses'] ?? [{}]);
    _children =
        List<Map<String, dynamic>>.from(widget.family['children'] ?? []);

    // Ensure each child has a 'gender' key
    for (var child in _children) {
      child['gender'] ??= 'M'; // Default to 'M' if gender is null
    }
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Parent Information'),
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Please update the primary parent or guardian\'s information.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                  helperText: 'Enter the first name of the primary guardian.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                  helperText: 'Enter the last name of the primary guardian.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  helperText:
                      'We will use this email to send important updates.',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address.';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text(
                  'Your information is confidential and will be used only for communication purposes.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Contact Information'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update your primary and secondary contact numbers.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _primaryPhoneController,
              decoration: const InputDecoration(
                labelText: 'Primary Phone',
                border: OutlineInputBorder(),
                helperText:
                    'Used to schedule appointments and announcements via Twilio.',
                helperMaxLines: 2,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your primary phone number.';
                }
                final phoneRegex = RegExp(r'^\d{10}$');
                if (!phoneRegex.hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _secondaryPhoneController,
              decoration: const InputDecoration(
                labelText: 'Secondary Phone',
                border: OutlineInputBorder(),
                helperText: 'Alternate number if we cannot reach you.',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text(
                'Your contact information is kept confidential.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Household Information'),
        content: Column(
          children: [
            const Text(
              'Update your household information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _adultMembersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Adults',
                border: OutlineInputBorder(),
                helperText: 'Include all adults living in your household.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of adults.';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _childMembersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Children',
                border: OutlineInputBorder(),
                helperText: 'Include all children living in your household.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of children.';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Is Active'),
              subtitle:
                  const Text('Uncheck if the family is no longer active.'),
              value: _isActive,
              onChanged: (bool value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(
                'This helps us keep our records up to date.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Addresses'),
        content: Column(
          children: [
            const Text(
              'Update your address information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ..._addresses.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> address = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Address Line 1',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: address['addr1'] ?? '',
                    onChanged: (value) {
                      address['addr1'] = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: address['city'] ?? '',
                    onChanged: (value) {
                      address['city'] = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the city.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: address['state'] ?? '',
                    onChanged: (value) {
                      address['state'] = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the state.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Zip Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: address['zipcode'] ?? '',
                    onChanged: (value) {
                      address['zipcode'] = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the zip code.';
                      }
                      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                        return 'Please enter a valid 5-digit zip code.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Address Verified'),
                    subtitle:
                        const Text('Check if the address has been verified.'),
                    value: address['verified'] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        address['verified'] = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement address verification logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Address verification is not implemented.')),
                      );
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Verify Address'),
                  ),
                  const Divider(thickness: 1, height: 30),
                ],
              );
            }),
            ElevatedButton(
              onPressed: _addAnotherAddress,
              child: const Text('Add Another Address'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text(
                'Your address information is confidential and used for service eligibility.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Children'),
        content: Column(
          children: [
            const Text(
              'Update information about your children.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_children.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No children added yet.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ..._children.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> child = entry.value;

              // Initialize gender if not already set
              child['gender'] ??= 'M';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Child ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeChild(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Pant Size',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: child['pant_size'] ?? '',
                    onChanged: (value) {
                      child['pant_size'] = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Shirt Size',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: child['shirt_size'] ?? '',
                    onChanged: (value) {
                      child['shirt_size'] = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      hintText: 'MM/DD/YYYY',
                    ),
                    keyboardType: TextInputType.datetime,
                    initialValue: child['dob'] ?? '',
                    onChanged: (value) {
                      child['dob'] = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the date of birth.';
                      }
                      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                        return 'Please enter a valid date in MM/DD/YYYY format.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: child['gender'],
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: _genderOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value'],
                        child: Text(option['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        child['gender'] = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a gender.';
                      }
                      return null;
                    },
                  ),
                  const Divider(thickness: 1, height: 30),
                ],
              );
            }),
            ElevatedButton(
              onPressed: _addAnotherChild,
              child: const Text('Add a Child'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(
                'Children\'s information helps us provide appropriate services.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
      Step(
        title: const Text('Confirmation'),
        content: Column(
          children: [
            const Text(
              'Please review the information before saving.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Edited by: $_editedBy'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text(
                'By saving, you confirm that all information provided is accurate.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 5,
      ),
    ];
  }

  void _addAnotherAddress() {
    setState(() {
      _addresses.add({});
    });
  }

  void _addAnotherChild() {
    setState(() {
      _children.add({});
    });
  }

  void _removeChild(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Child'),
          content: const Text('Are you sure you want to remove this child?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  _children.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _onStepContinue() {
    if (_currentStep < getSteps().length - 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      // Final step, submit the form
      if (_formKey.currentState?.validate() ?? false) {
        _submitFamilyDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please correct errors before saving.'),
          ),
        );
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _submitFamilyDetails() {
    // Collect all the data and submit
    Map<String, dynamic> updatedFamilyData = {
      'parent_1_fname': _firstNameController.text,
      'parent_1_lname': _lastNameController.text,
      'email': _emailController.text,
      'primary_phone': _primaryPhoneController.text,
      'secondary_phone': _secondaryPhoneController.text,
      'household_adult_members':
          int.tryParse(_adultMembersController.text) ?? 0,
      'household_child_members':
          int.tryParse(_childMembersController.text) ?? 0,
      'isActive': _isActive ? '1' : '0',
      'addresses': _addresses,
      'children': _children,
      'edited_by': _editedBy,
    };

    // TODO: Implement update logic (e.g., send data to backend)

    debugPrint('Updated Family Details:');
    debugPrint(updatedFamilyData.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family details updated successfully!'),
      ),
    );

    // Navigate back to ManageFamiliesPage after submission
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ManageFamiliesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Optionally, retrieve the current user's name
    // For example, _editedBy = currentUser.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Family'),
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
