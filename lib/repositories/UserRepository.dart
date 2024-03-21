import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/main.dart';

import '../models/user_model.dart';
import '../services/cache_manager/cache_manager.dart';

/// UserRepository is a class designed to
/// handle all user-related operations such as
/// fetching, saving, updating, and deleting user data.
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomCacheManager _cacheManager = CustomCacheManager();
  final String peakUserKey = 'peak_user';

  /// Fetch the user from the DB or cache
  Future<PeakUser?> fetchUser() async {
    logger.info('Fetching user data');
    var cachedUserData = await _cacheManager.getCachedData(peakUserKey);

    if (cachedUserData != null) {
      logger.info('Using cached user data');
      return PeakUser.fromJson(json.decode(cachedUserData));
    } else {
      logger.info('Fetching user data from Firestore');
      var doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (doc.exists) {
        logger.info('Caching user data');
        await _cacheManager.cacheData(peakUserKey, json.encode(doc.data()));

        logger.info('Returning user data from Firestore');
        return PeakUser.fromJson(doc.data()!);
      } else {
        logger.info('No user data found');
        return null;
      }
    }
  }

  /// Save the user to the DB and cache
  Future<bool> saveUser(PeakUser user) async {
    try {
      logger.info('Saving user: ${user.email}');
      await _firestore
          .collection('users')
          .doc(user.userId)
          .set(user.toJson())
          .then((_) {
        logger.info('User saved successfully');
      }).catchError((error) {
        logger.error('DB error: $error');
      });

      logger.info('Saving user to cache');
      await _cacheManager.cacheData(peakUserKey, json.encode(user.toJson()));

      return true;
    } catch (e) {
      logger.error('Failed to save user: $e');
      return false;
    }
  }

  /// Update the user in the DB and cache
  Future<bool> updateUserValue(PeakUser user, PUEnum key, dynamic value) async {
    // Update the cache
    try {
      await _cacheManager.cacheData(peakUserKey, json.encode(user.toJson()));
      logger.info('Updated ${user.firstName} ${user.lastName} cache record');
    } catch (e) {
      logger.error('Failed to update cache: $e');
      return false;
    }

    // Update the DB
    try {
      logger.info(
          'Updating ${user.firstName} ${user.lastName} DB record with $key: $value');
      await _firestore
          .collection('users')
          .doc(user.userId)
          .set(user.toJson(), SetOptions(merge: true))
          .then((_) {
        logger.info(
            'Updated ${user.firstName} ${user.lastName} DB record successfully');
      }).catchError((error) {
        logger.error('DB error: $error');
      });
      return true;
    } catch (e) {
      logger.error('Failed to update user: $e');
      return false;
    }
  }

  /// Insert the user into the DB and cache
  Future<bool> insertUser(PeakUser userInfo) async {
    // Insert the user into the cache
    try {
      logger.info('Inserting user: ${userInfo.email}');
      await _cacheManager.cacheData(
          peakUserKey, json.encode(userInfo.toJson()));
    } catch (e) {
      logger.error('Failed to insert user into cache: $e');
      return false;
    }

    // Insert the user into the DB
    try {
      logger.info('Inserting user: ${userInfo.email}');
      await _firestore
          .collection('users')
          .doc(userInfo.userId)
          .set(userInfo.toJson());
      return true;
    } catch (e) {
      logger.error('Failed to insert user: $e');
      return false;
    }
  }

  /// Delete the user from the DB and cache
  Future<void> deleteUser() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).delete();
      await _auth.currentUser!.delete();
      await _cacheManager.deleteCache(peakUserKey);
    } catch (e) {
      logger.error('Failed to delete user: $e');
    }
  }
}
