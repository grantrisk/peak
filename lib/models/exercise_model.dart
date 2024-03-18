import 'package:peak/models/exercise_history_model.dart';
import 'package:peak/models/exercise_set_model.dart';
import 'package:peak/models/workout_session_model.dart';

enum ExerciseEquipment { bodyWeight, dumbbell, barbell, machine, none }

enum ExerciseType { strength, cardio, flexibility }

class Exercise {
  String id;
  String name;
  String primaryMuscle;
  List<String> secondaryMuscles;
  List<ExerciseSet> sets;
  String owner = '';
  bool custom;
  ExerciseType type;
  ExerciseEquipment equipment;
  int? difficulty; // 1-10
  WorkoutSession? lastWorkoutSession;
  ExerciseHistory? history;

  Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.owner,
    required this.custom,
    required this.type,
    required this.equipment,
    this.sets = const [],
    this.difficulty,
    this.lastWorkoutSession,
    this.history,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var musclesWorked = json['muscles_worked'] ?? {};
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      primaryMuscle: musclesWorked['primary'] ?? '',
      secondaryMuscles: musclesWorked['secondary'] != null
          ? List<String>.from(musclesWorked['secondary'])
          : [],
      owner: json['owner'] ?? 'NULL',
      custom: json['custom'] ?? false,
      type: stringToExerciseType(json['type']),
      equipment: stringToExerciseEquipment(json['equipment']),
      sets: json['sets'] != null
          ? List<ExerciseSet>.from(
              json['sets'].map((model) => ExerciseSet.fromJson(model)))
          : [],
      difficulty: json['difficulty'] ?? 5,
      lastWorkoutSession: json['last_workout_session'] != null
          ? WorkoutSession.fromJson(json['last_workout_session'])
          : null,
      history: json['history'] != null
          ? ExerciseHistory.fromJson(json['history'])
          : null,
    );
  }

  @override
  String toString() {
    return '$name';
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'muscles_worked': {
        'primary': primaryMuscle,
        'secondary': secondaryMuscles,
      },
      'owner': owner,
      'custom': custom,
      'type': exerciseTypeToString(type),
      'equipment': exerciseEquipmentToString(equipment),
      'sets': sets.map((e) => e.toJson()).toList(),
      'difficulty': difficulty,
      'last_workout_session':
          lastWorkoutSession != null ? lastWorkoutSession!.id : null,
      'history': history != null ? history!.toJson() : null,
    };
  }
}

ExerciseType stringToExerciseType(String? typeString) {
  return ExerciseType.values.firstWhere(
    (type) => type.toString().split('.').last == typeString,
    orElse: () => ExerciseType.strength, // Default value if not found
  );
}

ExerciseEquipment stringToExerciseEquipment(String? equipmentString) {
  return ExerciseEquipment.values.firstWhere(
    (equipment) => equipment.toString().split('.').last == equipmentString,
    orElse: () => ExerciseEquipment.none, // Default value if not found
  );
}

String exerciseTypeToString(ExerciseType type) {
  return type.toString().split('.').last;
}

String exerciseEquipmentToString(ExerciseEquipment equipment) {
  return equipment.toString().split('.').last;
}
