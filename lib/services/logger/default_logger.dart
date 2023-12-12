import 'dart:io';

import 'package:intl/intl.dart';

import '../../utils/notification_service.dart';
import 'logger_config.dart';
import 'logger_interface.dart';

// The DefaultLogger class implements the Logger interface to provide a default logging implementation.
class DefaultLogger implements Logger {
  // Config object containing settings like log level and destination
  final LoggerConfig config;

  // Constructor requiring a LoggerConfig object
  DefaultLogger({required this.config});

  // Override of debug method from Logger interface to log debug messages
  @override
  void debug(String message, {Map<String, dynamic>? metadata}) {
    // Only log if the configured log level allows for debug messages
    if (config.logLevel.index <= LogLevel.debug.index) {
      _log("DEBUG", message, metadata);
    }
  }

  // Override of info method from Logger interface to log info messages
  @override
  void info(String message, {Map<String, dynamic>? metadata}) {
    // Only log if the configured log level allows for info messages
    if (config.logLevel.index <= LogLevel.info.index) {
      _log("INFO", message, metadata);
    }
  }

  // Override of warn method from Logger interface to log warning messages
  @override
  void warn(String message, {Map<String, dynamic>? metadata}) {
    // Only log if the configured log level allows for warning messages
    if (config.logLevel.index <= LogLevel.warn.index) {
      _log("WARN", message, metadata);
    }
  }

  // Override of error method from Logger interface to log error messages
  @override
  void error(String message, {Map<String, dynamic>? metadata}) {
    // Only log if the configured log level allows for error messages
    if (config.logLevel.index <= LogLevel.error.index) {
      _log("ERROR", message, metadata);
    }
  }

  // Override of critical method from Logger interface to log critical messages
  @override
  void critical(String message, {Map<String, dynamic>? metadata}) {
    // Only log if the configured log level allows for critical messages
    if (config.logLevel.index <= LogLevel.critical.index) {
      _log("CRITICAL", message, metadata);
    }
  }

  // Private method to notify team of logging failure via a notification service
  void _notifyLoggingFailure(dynamic error) {
    // Sending alert to the team about the logging failure via a notification service
    NotificationService().sendAlert('Logging Service Error: $error');
  }

  // Private method to handle the actual logging based on configuration
  void _log(String level, String message, Map<String, dynamic>? metadata) {
    try {
      // Get the current date and time
      final now = DateTime.now();

      // Format the date and time
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // Formatting log message with optional metadata
      final logMessage = metadata != null
          ? "$formattedDate $level: $message - Metadata: ${metadata.toString()}"
          : "$formattedDate $level: $message";

      // Switch statement to handle logging to different destinations based on configuration
      switch (config.destination) {
        case LogDestination.console:
          // Logging to console
          print(logMessage);
          break;

        case LogDestination.file:
          // Logging to file, ensuring a file path is provided
          if (config.filePath == null) {
            throw Exception("File path not provided for file-based logging.");
          }
          // Appending log message to specified file
          File(config.filePath!)
              .writeAsStringSync('$logMessage\n', mode: FileMode.append);
          break;

        // Placeholder for adding more log destinations in the future
        // Add more destinations as required in the future.
      }
    } catch (e) {
      // Handling any exceptions by notifying the team of logging failure
      _notifyLoggingFailure(e);
    }
  }
}
