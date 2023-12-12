import 'default_logger.dart';
import 'logger_config.dart';
import 'logger_interface.dart';
// import 'logger_middleware.dart';

enum LoggerType {
  defaultLogger,
  // middleWareLogger,
}

class LoggerServiceFactory {
  static Logger create(LoggerType type, LoggerConfig config) {
    switch (type) {
      case LoggerType.defaultLogger:
        return DefaultLogger(config: config);
      // case LoggerType.middleWareLogger:
      //   return LoggerMiddleware(config: config);
      default:
        throw UnimplementedError('Logger type not supported');
    }
  }
}
