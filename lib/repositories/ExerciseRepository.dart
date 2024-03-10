import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/main.dart';

import '../models/exercise_model.dart';
import '../services/cache_manager/cache_manager.dart';

class ExerciseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CustomCacheManager _cacheManager = CustomCacheManager();

  Future<List<Exercise>> fetchExercises() async {
    String cacheKey = 'default_exercises';
    logger.info('Fetching exercises from cache or Firestore');
    var cachedData = await _cacheManager.getCachedData(cacheKey);

    if (cachedData != null) {
      logger.info('Using cached data');
      Iterable l = json.decode(cachedData);

      return List<Exercise>.from(l.map((model) => Exercise.fromJson(model)));
    } else {
      logger.info('Fetching data from Firestore');
      var collection = await _firestore.collection('default_exercises').get();

      List<Exercise> exercises =
          collection.docs.map((doc) => Exercise.fromJson(doc.data())).toList();
      logger.info('Caching data');

      await _cacheManager.cacheData(
          cacheKey, json.encode(exercises.map((e) => e.toJson()).toList()));
      return exercises;
    }
  }
}
