import 'package:flutter/cupertino.dart';
import 'package:peak/models/exercise_model.dart';
import 'package:peak/models/user_goal_model.dart';

class WorkoutSession {
  String id = UniqueKey().toString();
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
}
