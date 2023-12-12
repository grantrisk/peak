// Enumeration defining the different log levels
enum LogLevel {
  debug, // Debug level for development and debugging
  info, // Info level for general information logging
  warn, // Warning level for potential issues
  error, // Error level for error logging
  critical, // Critical level for severe error logging
  none, // No logging will occur at this level
}

// Enumeration defining the different log destinations
enum LogDestination {
  console, // Logs will be output to the console
  file, // Logs will be written to a file
  // ... any other destinations can be added here
}

// Class to encapsulate the configuration for the logger
class LoggerConfig {
  // Property to hold the log level setting
  final LogLevel logLevel;

  // Property to hold the log destination setting
  final LogDestination destination;

  // Property to hold the file path for file logging (if applicable)
  final String? filePath; // Only needed for file logging

  // Constructor to create a LoggerConfig object with optional parameters
  // Default values are provided for logLevel and destination
  LoggerConfig({
    this.logLevel = LogLevel.debug, // Default log level is debug
    this.destination = LogDestination.console, // Default destination is console
    this.filePath, // File path is optional and defaults to null
  });
}
