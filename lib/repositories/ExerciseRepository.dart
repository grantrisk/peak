import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/main.dart';

import '../models/exercise_model.dart';
import '../services/cache_manager/cache_manager.dart';

class ExerciseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomCacheManager _cacheManager = CustomCacheManager();
  final String defaultExerciseKey = 'default_exercises';
  final String customExerciseKey = 'exercises';

  Future<List<Exercise>> fetchExercises() async {
    logger.info('Fetching exercises');
    var cachedDataDefaultExercises =
        await _cacheManager.getCachedData(defaultExerciseKey);
    var cachedDataExercises =
        await _cacheManager.getCachedData(customExerciseKey);

    if (cachedDataDefaultExercises != null && cachedDataExercises != null) {
      logger.info('Using cached data');
      Iterable l = json.decode(cachedDataDefaultExercises);
      Iterable l2 = json.decode(cachedDataExercises);

      return List<Exercise>.from(l.map((model) => Exercise.fromJson(model))) +
          List<Exercise>.from(l2.map((model) => Exercise.fromJson(model)));
    } else {
      logger.info('Fetching default exercises from Firestore');
      var collection = await _firestore.collection(defaultExerciseKey).get();

      List<Exercise> defaultExercises =
          collection.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      logger.info('Caching default exercises data');
      await _cacheManager.cacheData(defaultExerciseKey,
          json.encode(defaultExercises.map((e) => e.toJson()).toList()));

      logger.info('Fetching user exercises from Firestore');
      var collection2 = await _firestore
          .collection(customExerciseKey)
          .where('owner', isEqualTo: _auth.currentUser!.uid)
          .get();

      List<Exercise> exercises =
          collection2.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      logger.info('Caching user exercises data');
      await _cacheManager.cacheData(customExerciseKey,
          json.encode(exercises.map((e) => e.toJson()).toList()));

      return defaultExercises + exercises;
    }
  }

  Future<bool> saveExercise(Exercise exercise) async {
    try {
      // Save the exercise to the database
      logger.info('Saving exercise: $exercise');
      await _firestore
          .collection(customExerciseKey)
          .doc(exercise.id)
          .set(exercise.toJson())
          .then((_) {
        logger.info('Exercise saved successfully');
      }).catchError((error) {
        logger.error('Failed to save exercise');
      });

      // Save the exercise to the cache
      logger.info('Saving exercise to cache');
      var cachedData = await _cacheManager.getCachedData(customExerciseKey);
      List<Exercise> exercises = [];
      if (cachedData != null) {
        Iterable l = json.decode(cachedData);
        exercises =
            List<Exercise>.from(l.map((model) => Exercise.fromJson(model)));
      }
      exercises.add(exercise);
      await _cacheManager.cacheData(customExerciseKey,
          json.encode(exercises.map((e) => e.toJson()).toList()));

      return true;
    } catch (e) {
      logger.error('Failed to save exercise');
      return false;
    }
  }
}
