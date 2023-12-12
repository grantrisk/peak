/// A generic logging interface that abstracts away the actual logging mechanism.
///
/// The logger interface provides methods to log messages at various log levels.
/// Each logging method accepts a primary message and an optional metadata map
/// to provide additional context about the log event.
///
/// The metadata can include information like error details, request parameters,
/// or other contextual data helpful for debugging or analytics.
abstract class Logger {
  /// Logs a debug message, typically used for development and debugging.
  ///
  /// - [message]: The main log message.
  /// - [metadata]: Additional contextual information about the log event.
  void debug(String message, {Map<String, dynamic>? metadata});

  /// Logs an informational message that highlights the progress of the application.
  ///
  /// - [message]: The main log message.
  /// - [metadata]: Additional contextual information about the log event.
  void info(String message, {Map<String, dynamic>? metadata});

  /// Logs a warning message about something that might cause a problem in the future.
  ///
  /// - [message]: The main log message.
  /// - [metadata]: Additional contextual information about the log event.
  void warn(String message, {Map<String, dynamic>? metadata});

  /// Logs an error message about something that failed but is recoverable.
  ///
  /// - [message]: The main log message.
  /// - [metadata]: Additional contextual information about the log event.
  void error(String message, {Map<String, dynamic>? metadata});

  /// Logs a critical error message that might cause the system to terminate.
  ///
  /// - [message]: The main log message.
  /// - [metadata]: Additional contextual information about the log event.
  void critical(String message, {Map<String, dynamic>? metadata});
}
