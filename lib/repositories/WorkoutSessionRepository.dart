import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/main.dart';

import '../models/workout_session_model.dart';
import '../services/cache_manager/cache_manager.dart';

class WorkoutSessionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CustomCacheManager _cacheManager = CustomCacheManager();
  final String peakUserKey = 'workout_session';

  /// Save the workout session to the DB and cache
  Future<bool> saveWorkoutSession(WorkoutSession workoutSession) async {
    try {
      logger.info('Saving workout session');
      await _firestore
          .collection('workout_sessions')
          .doc(workoutSession.id)
          .set(workoutSession.toJson())
          .then((_) {
        logger.info('Workout session saved successfully');
      }).catchError((error) {
        logger.error('DB error: $error');
      });

      logger.info('Saving workout session to cache');
      await _cacheManager.cacheData(
          peakUserKey, json.encode(workoutSession.toJson()));

      return true;
    } catch (e) {
      logger.error('Failed to save workout session: $e');
      return false;
    }
  }
}
