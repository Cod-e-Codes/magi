import 'package:flutter/material.dart';
import '../screens/edit_family_page.dart';
import '../utils/database_helper.dart';

class FamilyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> family;

  const FamilyDetailsPage({super.key, required this.family});

  @override
  FamilyDetailsPageState createState() => FamilyDetailsPageState();
}

class FamilyDetailsPageState extends State<FamilyDetailsPage> {
  List<dynamic> addresses = [];
  List<dynamic> children = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchRelatedData();
  }

  Future<void> _fetchRelatedData() async {
    try {
      // Fetch addresses and children using the parent_id from the family
      int parentId = int.parse(widget.family['id'].toString());

      addresses = await DatabaseHelper.fetchTableDataWithParentId('address', parentId);
      if (addresses.isEmpty) {
        debugPrint('No addresses found for parent ID: $parentId');
      }

      children = await DatabaseHelper.fetchTableDataWithParentId('child', parentId);
      if (children.isEmpty) {
        debugPrint('No children found for parent ID: $parentId');
      }

      // No related data
      if (addresses.isEmpty && children.isEmpty) {
        throw Exception('No related data found for parent ID: $parentId');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        debugPrint("Error fetching data for parent ID ${widget.family['id']}: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLargeScreen = MediaQuery.of(context).size.width >= 800;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Text(
          'Failed to load data.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

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
                'Family: ${widget.family['parent_1_fname'] ?? ''} ${widget.family['parent_1_lname'] ?? ''}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(context, 'Name',
                  '${widget.family['parent_1_fname'] ?? 'No First Name'} ${widget.family['parent_1_lname'] ?? 'No Last Name'}'),
              _buildDetailRow(context, 'ID', widget.family['id'] ?? 'N/A'),
              _buildDetailRow(context, 'Primary Email',
                  widget.family['email'] ?? 'No Email Available'),
              _buildDetailRow(context, 'Primary Phone',
                  '${widget.family['primary_phone'] ?? 'No Primary Phone'} (${widget.family['primary_phone_type'] ?? 'N/A'})'),
              _buildDetailRow(context, 'Secondary Phone',
                  '${widget.family['secondary_phone'] ?? 'No Secondary Phone'} (${widget.family['secondary_phone_type'] ?? 'N/A'})'),
              _buildDetailRow(context, 'Household Adult Members',
                  widget.family['household_adult_members'] ?? 'N/A'),
              _buildDetailRow(context, 'Household Child Members',
                  widget.family['household_child_members'] ?? 'N/A'),
              _buildDetailRow(context, 'Family Notes',
                  widget.family['family_notes'] ?? 'No Notes Available'),
              _buildDetailRow(context, 'Active Status',
                  widget.family['isActive'] == '1' ? 'Active' : 'Inactive'),
              const SizedBox(height: 20),

              // Display Addresses
              if (addresses.isEmpty)
                Text('No addresses found.', style: Theme.of(context).textTheme.bodyMedium)
              else
                ...[
                  Text('Addresses', style: Theme.of(context).textTheme.titleMedium),
                  ...addresses.map((address) => _buildAddressRow(context, address)),
                ],

              const SizedBox(height: 20),

              // Display Children
              if (children.isEmpty)
                Text('No children found.', style: Theme.of(context).textTheme.bodyMedium)
              else
                ...[
                  Text('Children', style: Theme.of(context).textTheme.titleMedium),
                  ...children.map((child) => _buildChildRow(context, child)),
                ],

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Include addresses and children in the family object
                  Map<String, dynamic> updatedFamily = {
                    ...widget.family,
                    'addresses': addresses,
                    'children': children,
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditFamilyPage(family: updatedFamily),
                    ),
                  );
                },
                child: Text(
                  'Edit Family',
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

    if (isLargeScreen) {
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Family: ${widget.family['parent_1_fname'] ?? ''} ${widget.family['parent_1_lname'] ?? ''}',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        body: content,
      );
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
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

  // Build address rows
  Widget _buildAddressRow(BuildContext context, Map<String, dynamic> address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, 'Address', address['addr1'] ?? 'N/A'),
          _buildDetailRow(context, 'City', address['city'] ?? 'N/A'),
          _buildDetailRow(context, 'State', address['state'] ?? 'N/A'),
          _buildDetailRow(context, 'Zipcode', address['zipcode'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Build child rows
  Widget _buildChildRow(BuildContext context, Map<String, dynamic> child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Child ${child['child_num']} (${child['id']})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _buildDetailRow(context, 'Date of Birth', child['dob'] ?? 'N/A'),
          _buildDetailRow(context, 'Gender', child['gender'] ?? 'N/A'),
          _buildDetailRow(context, 'Pant Size', child['pant_size'] ?? 'N/A'),
          _buildDetailRow(context, 'Shirt Size', child['shirt_size'] ?? 'N/A'),
        ],
      ),
    );
  }
}
