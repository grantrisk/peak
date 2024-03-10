import 'package:cloud_firestore/cloud_firestore.dart';

import '../logger/logger.dart';
import 'abstract_db_service.dart';

class FirebaseDatabaseService extends AbstractDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Static variable to hold the singleton instance
  static FirebaseDatabaseService? _instance;

  // Static variable to hold the logger instance
  static Logger? _logger;

  // Private constructor to initialize the firestore and logger.
  FirebaseDatabaseService._internal() : super(_logger!);

  // Factory method to provide a singleton instance.
  factory FirebaseDatabaseService.getInstance(Logger logger) {
    _logger = logger; // Initialize logger
    return _instance ??= FirebaseDatabaseService._internal();
  }

  @override
  Future<void> insert(
      String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).set(data);
    logger.info('Inserted document with ID $docId into $collection');
  }

  @override
  Future<void> update(String collection, Map<String, dynamic> data,
      Map<String, dynamic> criteria) async {
    var docId = criteria['docId'];
    if (docId != null) {
      await _firestore.collection(collection).doc(docId).update(data);
      logger.info('Updated document in $collection');
    } else {
      logger.warn('Update criteria did not contain a docId');
    }
  }

  @override
  Future<void> delete(
      String collection, String docId, Map<String, dynamic> criteria) async {
    if (docId != null) {
      await _firestore.collection(collection).doc(docId).delete();
      logger.info('Deleted document from $collection');
    } else {
      logger.warn('Delete criteria did not contain a docId');
    }
  }

  @override
  Future<Map<String, dynamic>?> find(
      String collection, Map<String, dynamic> criteria) async {
    var docId = criteria['docId'];
    if (docId != null) {
      var doc = await _firestore.collection(collection).doc(docId).get();
      logger.info('Found document in $collection');
      return doc.data();
    } else {
      logger.warn('Find criteria did not contain a docId');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> findAll(
      String collection, Map<String, dynamic> criteria) async {
    var querySnapshot = await _firestore.collection(collection).get();
    var docs = querySnapshot.docs.map((doc) => doc.data()).toList();
    logger.info('Found ${docs.length} documents in $collection');
    return docs;
  }

  @override
  Future<void> deleteAll(String collection) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> connect() {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    throw UnimplementedError();
  }
}
