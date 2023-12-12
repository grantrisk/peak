import '../logger/logger.dart';
import 'abstract_db_service.dart';
import 'firebase_db_service.dart';

enum DatabaseType {
  local,
  firebase,
}

class DatabaseServiceFactory {
  static AbstractDatabaseService create(DatabaseType type, Logger logger) {
    switch (type) {
      case DatabaseType.firebase:
        // Create and pass the instance of FirebaseFirestore
        return FirebaseDatabaseService.getInstance(logger);
      case DatabaseType.local:
        // TODO: Handle this case.
        throw UnimplementedError();
      default:
        throw ArgumentError.notNull('type');
    }
  }
}
