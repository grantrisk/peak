import '../logger/logger.dart';

abstract class AbstractDatabaseService {
  final Logger logger;

  AbstractDatabaseService(this.logger);

  // Connect to the database
  Future<void> connect();

  // Disconnect from the database
  Future<void> disconnect();

  // Insert a new document into the database
  Future<void> insert(
      String collection, String docId, Map<String, dynamic> data);

  // Update a document in the database
  Future<void> update(String collection, Map<String, dynamic> data,
      Map<String, dynamic> criteria);

  // Delete a document from the database
  Future<void> delete(
      String collection, String docId, Map<String, dynamic> criteria);

  // Delete all documents from the database
  Future<void> deleteAll(String collection);

  // Find a document in the database
  Future<Map<String, dynamic>?> find(
      String collection, Map<String, dynamic> criteria);

  // Find all documents in the database
  Future<List<Map<String, dynamic>>> findAll(
      String collection, Map<String, dynamic> criteria);
}
