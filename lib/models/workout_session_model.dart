import 'exercise_model.dart';

class WorkoutSession {
  String id;
  DateTime date;
  List<Exercise> exercises;

  WorkoutSession(
      {required this.id, required this.date, List<Exercise>? exercises})
      : exercises = exercises ??
            []; // Providing a non-const default value using constructor body
}
