// magi_home_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../utils/database_helper.dart';
import '../widgets/toggling_dashboard_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_widget.dart';
import '../widgets/upcoming_events_widget.dart';
import '../widgets/scroll_to_top_fab.dart';
import '../screens/manage_families_page.dart';
import '../screens/manage_events_page.dart';
import '../screens/login_page.dart';
import '../screens/settings_page.dart';
import '../screens/privacy_policy_page.dart';
import '../screens/terms_of_service_page.dart';

class MagiHomePage extends StatefulWidget {
  const MagiHomePage({super.key});

  @override
  MagiHomePageState createState() => MagiHomePageState();
}

class MagiHomePageState extends State<MagiHomePage>
    with SingleTickerProviderStateMixin {
  Future<List<dynamic>> fetchData() async {
    try {
      return await DatabaseHelper.fetchTableData('parent');
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<List<dynamic>> fetchUpcomingEvents() async {
    try {
      return await DatabaseHelper.fetchUpcomingEvents();
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier(false);
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0, // Start the FAB fully transparent
    );

    // Check the scroll position after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollListener();
      }
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Check if the controller is attached before accessing the offset
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 200 && !_isFabVisible.value) {
        _isFabVisible.value = true;
        _fabAnimationController.forward(); // Fade in the FAB
      } else if (_scrollController.offset <= 200 && _isFabVisible.value) {
        _isFabVisible.value = false;
        _fabAnimationController.reverse(); // Fade out the FAB
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    _isFabVisible.dispose();
    super.dispose();
  }

  Future<void> _scrollToTop() async {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MAGI Ministries',
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              } else if (value == 'about') {
                showAboutDialog(
                  context: context,
                  applicationName: 'MAGI Ministries',
                  applicationVersion: '2.0.0',
                  applicationLegalese:
                      '© 2024 MAGI Ministries. All rights reserved.',
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColorFiltered(
                      colorFilter:
                          Theme.of(context).brightness == Brightness.dark
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : ColorFilter.mode(
                                  Colors.black,
                                  BlendMode
                                      .srcIn), // Use black filter in light mode
                      child: Image.asset(
                        'assets/magi_logo.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'MAGI Ministries is designed to help families with various activities and programs. '
                        'This app is a tool to manage and stay informed about families and upcoming events.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Developed by CodēCodes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri url =
                            Uri.parse('https://www.cod-e-codes.com');
                        await launchUrl(url);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'www.cod-e-codes.com',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                enabled: false,
                height: 0, // Set height to zero to minimize space
                child: Divider(
                  color:
                      Colors.black54, // Or use Theme.of(context).dividerColor
                  thickness: 1.0,
                  height: 1.0,
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 8),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                enabled: false,
                height: 0,
                child: Divider(
                  color:
                      Colors.black54, // Or use Theme.of(context).dividerColor
                  thickness: 1.0,
                  height: 1.0,
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Theme.of(context).cardColor,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'MAGI Ministries',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.home, color: Theme.of(context).iconTheme.color),
              title:
                  Text('Home', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.group, color: Theme.of(context).iconTheme.color),
              title: Text('Manage Families',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageFamiliesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.event, color: Theme.of(context).iconTheme.color),
              title: Text('Manage Events',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageEventsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard,
                  color: Theme.of(context).iconTheme.color),
              title: Text('Manage Christmas Program',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Manage Christmas Program functionality coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart,
                  color: Theme.of(context).iconTheme.color),
              title: Text('Reporting',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reporting functionality coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.download,
                  color: Theme.of(context).iconTheme.color),
              title: Text('Exports',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exports functionality coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // In your MagiHomePage build method
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([fetchData(), fetchUpcomingEvents()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Oops! Something went wrong while loading the data. Please try again later.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'No data available.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          } else {
            final List<dynamic> data = snapshot.data![0];
            final List<dynamic> events = snapshot.data![1];

            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            // Desktop layout with AlignedGridView
                            return AlignedGridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return TogglingDashboardCard(
                                    totalFamilies: data.length,
                                    activeFamilies: data
                                        .where(
                                            (item) => item['isActive'] == '1')
                                        .length,
                                    inactiveFamilies: data
                                        .where(
                                            (item) => item['isActive'] == '0')
                                        .length,
                                  );
                                } else if (index == 1) {
                                  return const QuickActionsCard();
                                } else if (index == 2) {
                                  return RecentActivityWidget(data: data);
                                } else {
                                  return UpcomingEventsWidget(events: events);
                                }
                              },
                            );
                          } else {
                            // Mobile layout with scrolling
                            return SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  TogglingDashboardCard(
                                    totalFamilies: data.length,
                                    activeFamilies: data
                                        .where(
                                            (item) => item['isActive'] == '1')
                                        .length,
                                    inactiveFamilies: data
                                        .where(
                                            (item) => item['isActive'] == '0')
                                        .length,
                                  ),
                                  const SizedBox(height: 16),
                                  const QuickActionsCard(),
                                  const SizedBox(height: 24),
                                  RecentActivityWidget(data: data),
                                  const SizedBox(height: 24),
                                  UpcomingEventsWidget(events: events),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isFabVisible,
        builder: (context, isVisible, child) {
          return IgnorePointer(
            ignoring: !isVisible, // Prevent interaction when the FAB is hidden
            child: FadeTransition(
              opacity: _fabAnimationController, // Smooth fade transition
              child: ScrollToTopFAB(
                onPressed: _scrollToTop,
                fabAnimation: _fabAnimationController,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surface, // Use a color from the ColorScheme
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to Privacy Policy Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage()),
                      );
                    },
                    child: const Text('Privacy Policy'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Terms of Service Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsOfServicePage()),
                      );
                    },
                    child: const Text('Terms of Service'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '© 2024 MAGI Ministries. All rights reserved.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
