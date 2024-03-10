import 'package:flutter/cupertino.dart';

import 'exercise_model.dart';

class WorkoutSession {
  String id = UniqueKey().toString();
  String owner = '';
  DateTime date;
  List<Exercise> exercises;

  WorkoutSession(
      {required this.date, required this.owner, List<Exercise>? exercises})
      : exercises = exercises ??
            []; // Providing a non-const default value using constructor body
}
