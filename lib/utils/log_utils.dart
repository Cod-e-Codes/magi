// log_utils.dart

import 'package:logger/logger.dart';

class LogUtils {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // Number of method calls to be displayed
      errorMethodCount: 5, // Number of method calls if stacktrace is provided
      lineLength: 80, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print emojis for each log
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}
