import 'package:peak/models/exercise_model.dart';
import 'package:peak/models/user_goal_model.dart';
import 'package:uuid/uuid.dart';

class WorkoutSession {
  String id = Uuid().v4();
  String owner = '';
  DateTime date;
  List<Exercise> exercises;
  Duration duration = Duration.zero;
  int? intensity; // 1-10
  List<UserGoal>? goals = [];
  String? notes = '';

  WorkoutSession(
      {required this.date,
      required this.owner,
      required this.exercises,
      required this.duration,
      this.intensity,
      this.goals,
      this.notes});

  static fromJson(json) {
    return WorkoutSession(
      date: DateTime.parse(json['date']),
      owner: json['owner'] ?? 'unknown',
      exercises: json['exercises'] != null
          ? List<Exercise>.from(
              json['exercises'].map((model) => Exercise.fromJson(model)))
          : [],
      duration: Duration(seconds: json['duration']),
      intensity: json['intensity'],
      goals: json['goals'] != null
          ? List<UserGoal>.from(
              json['goals'].map((model) => UserGoal.fromJson(model)))
          : [],
      notes: json['notes'],
    );
  }

  toJson() {
    return {
      'date': date.toIso8601String(),
      'owner': owner,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'duration': duration.inSeconds,
      'intensity': intensity,
      'goals': goals?.map((g) => g.toJson()).toList(),
      'notes': notes,
    };
  }
}
