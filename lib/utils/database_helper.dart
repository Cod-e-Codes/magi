import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'log_utils.dart';
import 'encryption_helper.dart';

class DatabaseHelper {
  static const String baseUrl =
      'https://pendletonunitedmagi.com/includes/test_api_function2.php';

  // Generic function to fetch data from a table
  static Future<List<dynamic>> fetchTableData(String tableName) async {
    String query = 'SELECT * FROM $tableName';

    try {
      // Encrypt the query
      final encryptedQuery = EncryptionHelper.encryptQuery(query);
      LogUtils.logger.d('Encrypted Query: $encryptedQuery'); // Keep logging encrypted query

      // Send the GET request
      final response = await http.get(
        Uri.parse('$baseUrl?$encryptedQuery'),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        String cleanedResponse = response.body.replaceAll('<br>', '');

        try {
          final List<dynamic> jsonData = json.decode(cleanedResponse);

          if (jsonData.isEmpty) {
            throw Exception("No data found or query returned an empty result.");
          }

          return jsonData;
        } catch (e) {
          LogUtils.logger.e("Error decoding JSON or invalid data structure", error: e); // Keep logging errors
          throw Exception("Failed to parse JSON or invalid data structure.");
        }
      } else {
        String errorMessage =
            'Query failed with status code: ${response.statusCode}';
        LogUtils.logger.e(errorMessage); // Log error message without body details
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogUtils.logger.e("An error occurred during the data fetch", error: e); // Keep logging exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Function to fetch data from a table with a parent_id filter
  static Future<List<dynamic>> fetchTableDataWithParentId(String tableName, int parentId) async {
    String query = 'SELECT * FROM $tableName WHERE parent_id = $parentId';

    try {
      final encryptedQuery = EncryptionHelper.encryptQuery(query);
      LogUtils.logger.d('Encrypted Query: $encryptedQuery');

      final response = await http.get(Uri.parse('$baseUrl?$encryptedQuery'));

      if (response.statusCode == 200) {
        String cleanedResponse = response.body.replaceAll('<br>', '');
        LogUtils.logger.d('API Response for $tableName: $cleanedResponse'); // Log full response

        // Check if the response is the error message string instead of valid JSON
        if (cleanedResponse.contains("The record(s) not found!")) {
          LogUtils.logger.d("No records found for parent_id = $parentId in $tableName.");
          return []; // Return an empty list when no records are found
        }

        // Try to decode the response as JSON
        final List<dynamic> jsonData = json.decode(cleanedResponse);
        if (jsonData.isEmpty) {
          throw Exception("No data found for parent_id = $parentId in $tableName.");
        }
        return jsonData;
      } else {
        String errorMessage = 'Query failed with status code: ${response.statusCode}';
        LogUtils.logger.e(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogUtils.logger.e("Error during data fetching: $e");
      throw Exception('Error during data fetching: $e');
    }
  }

  // Function to fetch upcoming events after today's date
  static Future<List<dynamic>> fetchUpcomingEvents() async {
    // Get the current date in 'YYYY-MM-DD HH:MM:SS' format
    String todayDate = DateTime.now().toIso8601String().split('T').join(' ').split('.')[0];
    String query = "SELECT * FROM event WHERE start_date_time > '$todayDate' ORDER BY start_date_time ASC";

    try {
      final encryptedQuery = EncryptionHelper.encryptQuery(query);
      LogUtils.logger.d('Encrypted Query for Events: $encryptedQuery'); // Keep logging encrypted query

      final response = await http.get(Uri.parse('$baseUrl?$encryptedQuery'));

      if (response.statusCode == 200) {
        String cleanedResponse = response.body.replaceAll('<br>', '');

        try {
          final List<dynamic> jsonData = json.decode(cleanedResponse);
          if (jsonData.isEmpty) {
            throw Exception("No upcoming events found.");
          }
          return jsonData;
        } catch (e) {
          LogUtils.logger.e("Error decoding JSON or invalid data structure for events", error: e); // Keep logging errors
          throw Exception("Failed to parse JSON or invalid data structure.");
        }
      } else {
        String errorMessage =
            'Query for events failed with status code: ${response.statusCode}';
        LogUtils.logger.e(errorMessage); // Log error message without body details
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogUtils.logger.e("An error occurred during the event data fetch", error: e); // Keep logging exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Fetch all event data without date restrictions
  static Future<List<dynamic>> fetchAllEvents() async {
    String query = "SELECT * FROM event ORDER BY start_date_time ASC";

    try {
      final encryptedQuery = EncryptionHelper.encryptQuery(query);
      LogUtils.logger.d('Encrypted Query for All Events: $encryptedQuery');

      final response = await http.get(Uri.parse('$baseUrl?$encryptedQuery'));

      LogUtils.logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        String cleanedResponse = response.body.replaceAll('<br>', '');
        LogUtils.logger.d('Cleaned Response: $cleanedResponse');

        try {
          final List<dynamic> jsonData = json.decode(cleanedResponse);
          LogUtils.logger.d('Decoded JSON Data: $jsonData'); // Log entire data

          if (jsonData.isEmpty) {
            throw Exception("No events found.");
          }
          return jsonData;
        } catch (e) {
          LogUtils.logger.e("Error decoding JSON for all events", error: e);
          throw Exception("Failed to parse JSON for all events.");
        }
      } else {
        String errorMessage = 'Query for all events failed with status code: ${response.statusCode}';
        LogUtils.logger.e(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogUtils.logger.e("An error occurred during the fetch for all events", error: e);
      throw Exception('An unexpected error occurred: $e');
    }
  }



  // Function for custom queries
  static Future<List<dynamic>> fetchDataWithCustomQuery(String customQuery) async {
    try {
      final encryptedQuery = EncryptionHelper.encryptQuery(customQuery);
      LogUtils.logger.d('Encrypted Query: $encryptedQuery'); // Keep logging encrypted query

      final response = await http.get(Uri.parse('$baseUrl?$encryptedQuery'));

      if (response.statusCode == 200) {
        String cleanedResponse = response.body.replaceAll('<br>', '');

        try {
          final List<dynamic> jsonData = json.decode(cleanedResponse);
          if (jsonData.isEmpty) {
            throw Exception("No data found or query returned an empty result.");
          }

          return jsonData;
        } catch (e) {
          LogUtils.logger.e("Error decoding JSON or invalid data structure", error: e); // Keep logging errors
          throw Exception("Failed to parse JSON or invalid data structure.");
        }
      } else {
        String errorMessage =
            'Query failed with status code: ${response.statusCode}';
        LogUtils.logger.e(errorMessage); // Log error message without body details
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogUtils.logger.e("An error occurred during the data fetch", error: e); // Keep logging exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
