// This middleware file provides a way to intercept service calls, allowing
// logging of requests and responses, as well as handling and logging of any errors
// that may occur during the service call. This is crucial for monitoring, debugging,
// and ensuring the reliable operation of the services.

// Importing the logger interface
import 'logger_interface.dart';

// Class defining a logging middleware to intercept and log service calls
class LoggerMiddleware {
  // Property to hold the logger instance
  final Logger _logger;

  // Constructor to initialize the middleware with a logger instance
  LoggerMiddleware(this._logger);

  // Method to log a service call, returning a Future of the same type as the service call
  Future<T> logServiceCall<T>(Future<T> Function() serviceCall,
      {String? serviceName}) async {
    try {
      // Logging the request to the service
      _logger.debug(
          'Request made to service: ${serviceName ?? 'Unnamed service'}');

      // Awaiting the response from the service call
      final response = await serviceCall();

      // Logging successful response from the service
      _logger.info(
          'Service: ${serviceName ?? 'Unnamed service'} responded successfully.');
      return response; // Returning the response from the service call
    } catch (e, stacktrace) {
      // Catching and logging any errors during the service call
      // Logging the error along with a stacktrace for debugging
      _logger.error(
          'Error in service: ${serviceName ?? 'Unnamed service'}. Error: $e',
          metadata: {'stacktrace': stacktrace.toString()});
      rethrow; // Rethrowing the error to be handled further up the call stack
    }
  }
}

/* ⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️
With this setup, whenever fetchData is called, the middleware will log the request's initiation, the response, or any errors that may
occur during the service call.

This is a basic demonstration, and depending on the actual structure and behavior of your services, adjustments might be needed.
But the principle remains: use the middleware to wrap service calls and handle logging transparently without having to sprinkle logging
code throughout the actual service methods.
 */

/*
// hypothetical_service.dart

import 'logger_middleware.dart';
import 'default_logger.dart';
import 'logger_config.dart';

class HypotheticalService {
  final LoggerMiddleware _middleware;

  HypotheticalService(Logger logger)
      : _middleware = LoggerMiddleware(logger);

  Future<String> fetchData() async {
    return await _middleware.logServiceCall(() async {
      await Future.delayed(Duration(seconds: 2));  // Simulate some network delay.
      return "Data from the service";
    }, serviceName: 'fetchData');
  }
}

void main() {
  final logger = DefaultLogger(config: LoggerConfig(logLevel: LogLevel.debug, destination: LogDestination.console));
  final service = HypotheticalService(logger);

  service.fetchData().then((data) => print('Received data: $data'));
}
*/
