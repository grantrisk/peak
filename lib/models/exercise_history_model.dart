import 'package:peak/models/exercise_set_model.dart';

class ExerciseHistory {
  String id;
  DateTime completedDate;
  List<ExerciseSet> sets;
  int totalWeightLifted;
  int totalReps;
  int totalSets;
  int averageWeight;
  int averageReps;

  ExerciseHistory({
    required this.id,
    required this.completedDate,
    required this.sets,
    required this.totalWeightLifted,
    required this.totalReps,
    required this.totalSets,
    required this.averageWeight,
    required this.averageReps,
  });

  static fromJson(json) {
    return ExerciseHistory(
      id: json['id'] ?? '',
      completedDate: DateTime.parse(json['completed_date']),
      sets: json['sets'] != null
          ? List<ExerciseSet>.from(
              json['sets'].map((model) => ExerciseSet.fromJson(model)))
          : [],
      totalWeightLifted: json['total_weight_lifted'] ?? 0,
      totalReps: json['total_reps'] ?? 0,
      totalSets: json['total_sets'] ?? 0,
      averageWeight: json['average_weight'] ?? 0,
      averageReps: json['average_reps'] ?? 0,
    );
  }

  toJson() {
    return {
      'id': id,
      'completed_date': completedDate.toIso8601String(),
      'sets': sets.map((s) => s.toJson()).toList(),
      'total_weight_lifted': totalWeightLifted,
      'total_reps': totalReps,
      'total_sets': totalSets,
      'average_weight': averageWeight,
      'average_reps': averageReps,
    };
  }
}
