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
}
