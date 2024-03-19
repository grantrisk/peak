import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/exercise_model.dart';

void main() {
  group('Exercise Model Tests', () {
    test('Exercise.fromJson creates an instance from JSON', () {
      const String jsonOwner = 'Test Owner';
      const bool jsonCustom = true;
      const String jsonType = 'strength';
      const String jsonEquipment = 'dumbbell';

      // Example JSON representation of an Exercise
      final Map<String, dynamic> json = {
        'id': '1',
        'name': 'Push Up',
        'muscles_worked': {
          'primary': 'Chest',
          'secondary': ['Triceps', 'Shoulders']
        },
        'owner': jsonOwner,
        'custom': jsonCustom,
        'type': jsonType,
        'equipment': jsonEquipment,
        'sets': [],
        'difficulty': 5
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.id, '1');
      expect(exercise.name, 'Push Up');
      expect(exercise.primaryMuscle, 'Chest');
      expect(exercise.secondaryMuscles, ['Triceps', 'Shoulders']);
      expect(exercise.owner, jsonOwner);
      expect(exercise.custom, jsonCustom);
      expect(exercise.type, ExerciseType.strength);
      expect(exercise.equipment, ExerciseEquipment.dumbbell);
      expect(exercise.sets, isEmpty);
      expect(exercise.difficulty, 5);
    });

    test('Exercise.toJson returns a JSON map from an Exercise instance', () {
      final exercise = Exercise(
        id: '1',
        name: 'Push Up',
        primaryMuscle: 'Chest',
        secondaryMuscles: ['Triceps', 'Shoulders'],
        owner: 'Test Owner',
        custom: true,
        type: ExerciseType.strength,
        equipment: ExerciseEquipment.dumbbell,
        sets: [],
        difficulty: 5,
      );

      final json = exercise.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Push Up');
      expect(json['muscles_worked']['primary'], 'Chest');
      expect(json['muscles_worked']['secondary'], ['Triceps', 'Shoulders']);
      expect(json['owner'], 'Test Owner');
      expect(json['custom'], true);
      expect(json['type'], 'strength');
      expect(json['equipment'], 'dumbbell');
      expect(json['sets'], isEmpty);
      expect(json['difficulty'], 5);
    });

    test('Exercise toJson and fromJson test with JSON string comparison', () {
      // Initial JSON map
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'name': 'Push Up',
        'muscles_worked': {
          'primary': 'Chest',
          'secondary': ['Triceps', 'Shoulders']
        },
        'owner': 'Test Owner',
        'custom': true,
        'type': 'strength',
        'equipment': 'dumbbell',
        'sets': [],
        'difficulty': 5,
      };

      final String expectedJsonString =
          '{"id":"1","name":"Push Up","muscles_worked":{"primary":"Chest","secondary":["Triceps","Shoulders"]},'
          '"owner":"Test Owner","custom":true,"type":"strength","equipment":"dumbbell","sets":[],"difficulty":5,'
          '"last_workout_session":null,"history":null}';

      // Create an Exercise instance from jsonMap
      final exercise = Exercise.fromJson(jsonMap);

      // Serialize the Exercise instance back to a JSON map
      final Map<String, dynamic> serializedJsonMap = exercise.toJson();

      // Convert the serialized map back to a JSON string
      final String actualJsonString = jsonEncode(serializedJsonMap);

      // Compare the normalized JSON strings
      expect(actualJsonString, expectedJsonString);
    });

    test('stringToExerciseType converts string to ExerciseType correctly', () {
      expect(stringToExerciseType("strength"), ExerciseType.strength);
      expect(stringToExerciseType("cardio"), ExerciseType.cardio);
      expect(stringToExerciseType("flexibility"), ExerciseType.flexibility);
      // Test for default fallback value
      expect(stringToExerciseType("unknown"), ExerciseType.strength);
    });

    test(
        'stringToExerciseEquipment converts string to ExerciseEquipment correctly',
        () {
      expect(stringToExerciseEquipment("bodyWeight"),
          ExerciseEquipment.bodyWeight);
      expect(stringToExerciseEquipment("dumbbell"), ExerciseEquipment.dumbbell);
      expect(stringToExerciseEquipment("barbell"), ExerciseEquipment.barbell);
      expect(stringToExerciseEquipment("machine"), ExerciseEquipment.machine);
      // Test for default fallback value
      expect(stringToExerciseEquipment("unknown"), ExerciseEquipment.none);
    });

    test('exerciseTypeToString converts ExerciseType to string correctly', () {
      expect(exerciseTypeToString(ExerciseType.strength), "strength");
      expect(exerciseTypeToString(ExerciseType.cardio), "cardio");
      expect(exerciseTypeToString(ExerciseType.flexibility), "flexibility");
    });

    test(
        'exerciseEquipmentToString converts ExerciseEquipment to string correctly',
        () {
      expect(exerciseEquipmentToString(ExerciseEquipment.bodyWeight),
          "bodyWeight");
      expect(exerciseEquipmentToString(ExerciseEquipment.dumbbell), "dumbbell");
      expect(exerciseEquipmentToString(ExerciseEquipment.barbell), "barbell");
      expect(exerciseEquipmentToString(ExerciseEquipment.machine), "machine");
      expect(exerciseEquipmentToString(ExerciseEquipment.none), "none");
    });
  });
}
