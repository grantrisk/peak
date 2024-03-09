# Logging Service

The Logging Service is a robust logging solution for Dart and Flutter projects, providing different log levels and
destinations. It's designed to be extensible and middleware-ready to accommodate various use cases.

## Getting Started

1. **Configuration**:
   - Firstly, define your logging configuration using the `LoggerConfig` class. Specify the `logLevel`
     and `destination` for your logs. Optionally, provide a `filePath` for file logging.

```dart
final config = LoggerConfig(
    logLevel: LogLevel.debug,
    destination: LogDestination.console,
    filePath: 'logs.txt' // Optional, only for file logging
);
```

2. **Initialization**:
   - To simplify the initialization, a factory class LoggerServiceFactory has been introduced. Utilize this factory to
     create an instance of a logger with the specified configuration.

```dart
final logger = DefaultLogger(config: config);
```

3. **Logging**:
   - Employ the logger instance to register messages at various levels.

```dart
logger.debug('This is a debug message');
logger.info('This is an info message');
logger.warn('This is a warning message');
logger.error('This is an error message');
logger.critical('This is a critical message');
```

4. **Middleware Usage**:
   - Utilize LoggerMiddleware to log service calls.

```dart
final middleware = LoggerMiddleware(logger);

// Wrap your service call with logServiceCall
var response = await middleware.logServiceCall(() async {
  // Your service call here
  return 'Service response';
}, serviceName: 'MyService');
```

## Error Handling

In case of a logging failure, an alert will be sent via the NotificationService. The current implementation of
NotificationService is a placeholder, and you would need to integrate it with your notification system (e.g., email or
Slack).

```dart
class NotificationService {
  void sendAlert(String message) {
    // TODO: Integrate with your notification system
    print('ALERT: $message');
  }
}
```

## Extending the Logger

The logging service is designed to be extensible. You can implement the Logger interface to create your custom logger or
extend DefaultLogger to override its behavior.

## Testing

Refer to the provided test file to understand how to test the logging service in your application.

## Simplified Import

To streamline the usage, all logger related classes and enums can be accessed by importing a single file:

```dart
import 'package:twinscript/core/services/logger/logger.dart';
```

This import statement will provide access to the Logger, LoggerConfig, DefaultLogger, and LoggerServiceFactory classes,
facilitating a cleaner and more manageable code structure.
