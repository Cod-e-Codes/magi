// manage_families_page.dart

import 'package:flutter/material.dart';
import '../screens/add_family_page.dart';
import '../screens/family_details_page.dart';
import '../utils/database_helper.dart';

class ManageFamiliesPage extends StatefulWidget {
  final bool autoFocusSearch;

  const ManageFamiliesPage({super.key, this.autoFocusSearch = false});

  @override
  ManageFamiliesPageState createState() => ManageFamiliesPageState();
}

class ManageFamiliesPageState extends State<ManageFamiliesPage> {
  List<dynamic> families = [];
  List<dynamic> filteredFamilies = [];
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? selectedFamily;

  Future<void> fetchFamilies() async {
    try {
      List<dynamic> data = await DatabaseHelper.fetchTableData('parent');
      setState(() {
        families = data;
        filteredFamilies = data;
      });
    } catch (e) {
      debugPrint("Error fetching families: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFamilies();
    searchController.addListener(() {
      filterFamilies();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // Trigger rebuild when dependencies change (e.g., theme change)
  }

  void filterFamilies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFamilies = families.where((family) {
        return (family['parent_1_fname'] ?? '')
            .toString()
            .toLowerCase()
            .contains(query) ||
            (family['parent_1_lname'] ?? '')
                .toString()
                .toLowerCase()
                .contains(query) ||
            (family['id'] ?? '').toString().toLowerCase().contains(query) ||
            (family['primary_phone'] ?? '')
                .toString()
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Families'), // Use const here since it's static text
      ),
      body: isLargeScreen
          ? Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                buildSearchBar(),
                Expanded(child: buildFamilyList(isLargeScreen)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedFamily != null
                ? FamilyDetailsPage(family: selectedFamily!)
                : Center(
              child: Text(
                'Select a family to view details',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
              ),
            ),
          ),
        ],
      )
          : Column(
        children: [
          buildSearchBar(),
          Expanded(child: buildFamilyList(isLargeScreen)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFamilyPage(),
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
          labelText: 'Search Families',
          prefixIcon: const Icon(Icons.search),
          labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
        ),
      ),
    );
  }

  Widget buildFamilyList(bool isLargeScreen) {
    String searchQuery = searchController.text.toLowerCase();

    return families.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      key: ValueKey(Theme.of(context).brightness), // Force rebuild on theme change
      itemCount: filteredFamilies.length,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
      itemBuilder: (context, index) {
        var family = filteredFamilies[index];


        String firstName = family['parent_1_fname'] ?? '';
        String lastName = family['parent_1_lname'] ?? '';
        String familyId = family['id'] ?? 'N/A';
        String phone = family['primary_phone'] ?? 'N/A';

        return Card(
          color: Theme.of(context).cardColor, // Use theme's card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: RichText(
              text: highlightSearchText(
                '$firstName $lastName',
                searchQuery,
                context,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: highlightSearchText(
                    'Family ID: $familyId',
                    searchQuery,
                    context,
                  ),
                ),
                RichText(
                  text: highlightSearchText(
                    'Phone: $phone',
                    searchQuery,
                    context,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.visibility),
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                if (isLargeScreen) {
                  setState(() {
                    selectedFamily = family;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamilyDetailsPage(family: family),
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

  // Updated method to use theme colors
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
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: normalStyle,
        ));
      }

      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + lowerQuery.length),
        style: highlightStyle,
      ));

      start = indexOfHighlight + lowerQuery.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
