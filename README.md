
# MAGI Ministries App

This is the source code for the MAGI Ministries app, created for Pendleton Methodist Church in Pendleton, South Carolina. 
The app aims to assist in managing church events, families, and activities with a user-friendly interface and robust features.

## Features

- **User Authentication**
  - Login functionality for users.
  
- **Event Management**
  - Add, edit, delete, and view details of church events.
  - List and manage upcoming events.

- **Family Management**
  - Add, edit, delete, and view details of families within the church.

- **Dashboard**
  - Quick access to events and family details.
  - Recent activities and upcoming events widgets.

- **Settings**
  - Options for app customization, including themes and push notification preferences.

- **Privacy and Terms**
  - Dedicated pages for Privacy Policy and Terms of Service.

## Directory Structure

The project follows a modular architecture for maintainability and scalability.

### Key Files and Directories

#### **Main Entry Point**
- `lib/main.dart` - The entry point of the app.

#### **Screens**
- `lib/screens/add_event_page.dart` - Add new events.
- `lib/screens/add_family_page.dart` - Add new families.
- `lib/screens/edit_event_page.dart` - Edit existing events.
- `lib/screens/edit_family_page.dart` - Edit existing family details.
- `lib/screens/event_details_page.dart` - Detailed view of an event.
- `lib/screens/family_details_page.dart` - Detailed view of a family.
- `lib/screens/login_page.dart` - User login interface.
- `lib/screens/magi_home_page.dart` - The main dashboard/home page.
- `lib/screens/manage_events_page.dart` - Manage the list of events.
- `lib/screens/manage_families_page.dart` - Manage the list of families.
- `lib/screens/privacy_policy_page.dart` - Displays the Privacy Policy.
- `lib/screens/settings_page.dart` - App settings page.
- `lib/screens/terms_of_service_page.dart` - Displays the Terms of Service.

#### **Utilities**
- `lib/utils/database_helper.dart` - Database interaction utilities.
- `lib/utils/encryption_helper.dart` - Encryption utilities for secure data handling.
- `lib/utils/log_utils.dart` - Logging utilities for debugging.
- `lib/utils/theme.dart` - Theme and style definitions for the app.

#### **Widgets**
- `lib/widgets/quick_actions_card.dart` - Widget for displaying quick action buttons.
- `lib/widgets/recent_activity_widget.dart` - Widget to display recent activities.
- `lib/widgets/scroll_to_top_fab.dart` - Floating action button to scroll to the top.
- `lib/widgets/toggling_dashboard_card.dart` - Dynamic dashboard card widget.
- `lib/widgets/upcoming_events_widget.dart` - Widget for showing upcoming events.

## Development

### Prerequisites

- [Flutter](https://flutter.dev) (latest stable version)
- Dart SDK

### Getting Started

1. Clone this repository.
2. Run `flutter pub get` to install dependencies.
3. Start the app using `flutter run`.

## License

This project is developed for MAGI Ministries and Pendleton Methodist Church.

## Developed By

This app was proudly developed by [CodēCodes](https://www.cod-e-codes.com), also available on [GitHub](https://github.com/Cod-e-Codes).